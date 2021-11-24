#!/usr/bin/env bash

# update a docker-compose installation on debian/ubuntu

jq() {
  docker run --rm -i -v "${PWD}:/data" imega/jq "$@"
}

config()
{
  if [ "$(whoami)" = "root" ]
  then
    echo "It is not recommended to run this script as root. As a normal user, elevation will be prompted if needed."
    read -rp "Continue anyway? (y/n) " confirm </dev/tty
    if [[ "$confirm" = "n" ]]; then exit 1; fi
  else
    if ! command -v sudo
    then
      echo "Please install and configure sudo before running this script."
      echo "sudo was not found, exiting..."
      exit 1
    elif ! groups | grep sudo; then
      echo "Please add your current user to the sudoers."
      echo "You can run the following as root: \"usermod -aG sudo $(whoami)\", then logout and login again"
      echo "sudo was not configured, exiting..."
      exit 1
    fi
    if ! groups | grep docker; then
      echo "Please add your current user to the docker group."
      echo "You can run the following as root: \"usermod -aG docker $(whoami)\", then logout and login again"
      echo "current user is not allowed to use docker, exiting..."
      exit 1
    fi
  fi
  echo "detecting curl..."
  if ! command -v curl
  then
    echo "Please install curl before running this script."
    echo "curl was not found, exiting..."
    exit 1
  fi
  if ! command -v awk || ! [[ $(awk -W version) =~ ^GNU ]]
  then
    echo "Please install GNU Awk before running this script."
    echo "gawk was not found, exiting..."
    exit 1
  fi
  echo "checking memory..."
  mem=$(free -mt | grep Total | awk '{print $2}')
  if [ "$mem" -lt 4000 ]
  then
    read -rp "Not enough memory to perform upgrade. Would you like to add the necessary swap? (y/n) " swap </dev/tty
    if [ "$swap" = "y" ]
    then
      local swap_value=$((4096-$mem))
      sudo fallocate -l "${swap_value}M" /swapfile
      sudo chmod 600 /swapfile
      sudo mkswap /swapfile
      sudo swapon /swapfile
      echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
      echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
      echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
    else
      echo "Please upgrade memory to 4GB or more to allow the upgrade to run."
      free -h
      exit 7
    fi
  fi
  OLP_PATH=$(pwd)
  TYPE="NOT-FOUND"
  read -rp "Is OpenLab-projects installed at \"$OLP_PATH\"? (y/n) " confirm </dev/tty
  if [ "$confirm" = "y" ]
  then
    # checking disk space (minimum required = 1168323KB)
    space=$(df $OLP_PATH | awk '/[0-9]%/{print $(NF-2)}')
    if [ "$space" -lt 1258291 ]
    then
      echo "Not enough free disk space to perform upgrade. Please free at least 1,2GB of disk space and try again"
      df -h $OLP_PATH
      exit 7
    fi
    if [ -f "$OLP_PATH/config/env" ]
    then
      ES_HOST=$(cat "$OLP_PATH/config/env" | grep ELASTICSEARCH_HOST | awk '{split($0,a,"="); print a[2]}')
    else
      echo "OpenLab-projects' environment file not found, please run this script from the installation folder"
      exit 1
    fi
    ES_IP=$(getent ahostsv4 "$ES_HOST" | awk '{ print $1 }' | uniq)
  else
    echo "Please run this script from the OpenLab-projects' installation folder"
    exit 1
  fi
}

test_docker_compose()
{
  if [[ -f "$OLP_PATH/docker-compose.yml" ]]
  then
    docker-compose ps | grep elastic
    if [[ $? = 0 ]]
    then
      TYPE="DOCKER-COMPOSE"
      local container_id=$(docker-compose ps | grep elastic | awk '{print $1}')
      ES_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_id")
    fi
  fi
}

test_running()
{
  local http_res=$(curl -I "$ES_IP:9200" 2>/dev/null | head -n 1 | cut -d$' ' -f2)
  if [ "$http_res" = "200" ]
  then
    echo "ONLINE"
  else
    echo "OFFLINE"
  fi
}

test_version()
{
  local version=$(curl "$ES_IP:9200"  2>/dev/null | grep number | awk '{print $3}')
  case "$version" in
  *1.7*)
    echo "1.7"
    ;;
  *2.4*)
    echo "2.4"
    ;;
  *5.6*)
    echo "5.6"
    ;;
  *6.2*)
    echo "6.2"
    ;;
  *)
    echo "$version"
  esac
}

detect_installation()
{
  echo "Detecting installation type..."

  test_docker_compose
  if [[ "$TYPE" = "DOCKER-COMPOSE" ]]
  then
    echo "Docker-compose installation detected."
  fi

  if [[ "$TYPE" = "NOT-FOUND" ]]
  then
    echo "ElasticSearch 1.7 was not found on the current system, exiting..."
    exit 2
  else
    echo -n "Detecting online status... "
      STATUS=$(test_running)
      echo "$STATUS"
      if [ "$STATUS" = "OFFLINE" ]
      then
        echo "Your ElasticSearch instance is offline. Please check the logs and verify that no problems prevent the upgrade..."
        echo "Note: You can use \`docker-compose logs CONTAINER\` to view the logs";
        exit 3
      fi
  fi
}

error_index_status()
{
  echo "Your elasticSearch installation contains indices which states are not \"green\", but this cannot be solved automatically."
  echo "Please solve theses status before continuing..."
  curl "$ES_IP:9200/_cat/indices?v" 2>/dev/null | grep --color -E "yellow|red|$"
  exit 6
}

ensure_initial_status_green()
{
  echo "Checking status of your elasticSearch indices..."
  local state=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{print $1}' | sort | uniq)
  if [ "$state" != "green" ]
  then
    local replicas=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{print $5}' | sort | uniq)
    if [ "$replicas" != "0" ]
    then
      local indices=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{print $3}')
      for index in $indices # do not surround $indices with quotes
      do
        curl -XPUT "$ES_IP:9200/$index/_settings" 2>/dev/null -H 'Content-Type: application/json' -d '{
          "index": {
            "number_of_replicas": 0
          }
        }'
      done
      local final_state=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{print $1}' | sort | uniq)
      if [ "$final_state" != "green" ]; then error_index_status; fi
    else
      error_index_status
    fi
  fi
}

wait_for_online()
{
  local counter=0
  echo -n "Waiting for ElasticSearch instance to came online"
  STATUS=$(test_running)
  while [ "$STATUS" != "ONLINE" ]
  do
    echo -n "."
    sleep 1
    STATUS=$(test_running)
    ((++counter))
    if [ "$counter" -eq 120 ]
    then
      echo -e "\nThe ElasticSearch instance did not came online for 2 minutes, please check the logs for any errors. Exiting..."
      exit 8
    fi
  done
  echo -e "\n"
}

wait_for_green_status()
{
  echo -n "Waiting for ElasticSearch indices to have green status"
  local state=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{print $1}' | sort | uniq)
  while [ "$state" != "green" ]
  do
    echo -n "."
    sleep 1
    state=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{print $1}' | sort | uniq)
  done
  echo -e "\n"
}

prepare_upgrade()
{
  curl -XPUT "$ES_IP:9200/_cluster/settings?pretty" 2>/dev/null -H 'Content-Type: application/json' -d'{
    "transient": {
      "cluster.routing.allocation.enable": "none"
    }
  }'
  curl -XPOST 2>/dev/null "$ES_IP:9200/_flush/synced?pretty"
}

reenable_allocation()
{
  curl -XPUT "$ES_IP:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'{
    "transient": {
      "cluster.routing.allocation.enable": "all"
    }
  }'
}

upgrade_compose()
{
  local current=$1
  local target=$2
  echo -e "\nUpgrading docker-compose installation from $current to $target..."
  prepare_upgrade
  docker-compose stop elasticsearch
  docker-compose rm -f elasticsearch
  local image="elasticsearch:$target"
  if [ $target = '6.2' ]; then image="docker.elastic.co\/elasticsearch\/elasticsearch-oss:6.2.3"; fi
  sed -i.bak "s/image: elasticsearch:$current/image: $image/g" "$OLP_PATH/docker-compose.yml"
  if ! grep -qe "ES_JAVA_OPTS" docker-compose.yml
  then
    sed -i.bak "/image: $image/s/.*/&\n    environment:\n      - \"ES_JAVA_OPTS=-Xms512m -Xmx512m\"/" "$OLP_PATH/docker-compose.yml"
  fi
  if ! grep -qe "ulimits" docker-compose.yml
  then
    sed -i.bak "/image: $image/s/.*/&\n    ulimits:\n      memlock:\n        soft: -1\n        hard: -1/" "$OLP_PATH/docker-compose.yml"
  fi
  if [ $target = '2.4' ]
  then
    # get current data directory
    dir=$(awk 'BEGIN { FS="\n"; RS="";} { match($0, /image: elasticsearch:2\.4(\n|.)+volumes:(\n|.)+(-.*elasticsearch\/data)/, lines); FS="[ :]+"; RS="\r\n"; split(lines[3], line); print line[2] }' "$OLP_PATH/docker-compose.yml")
    # set the configuration directory
    dir=$(echo "${dir//[$'\t\r\n ']}/config")
    # insert configuration directory into docker-compose bindings
    awk "BEGIN { FS=\"\n\"; RS=\"\";} { print gensub(/(image: elasticsearch:2\.4(\n|.)+volumes:(\n|.)+(-.*elasticsearch\/data))/, \"\\\\1\n      - ${dir}:/usr/share/elasticsearch/config\", \"g\") }" "$OLP_PATH/docker-compose.yml" > "$OLP_PATH/.awktmpfile" && mv "$OLP_PATH/.awktmpfile" "$OLP_PATH/docker-compose.yml"
    abs_dir=$(echo "$dir" | sed "s^\${PWD}^$OLP_PATH^")
    echo -e "\nCopying ElasticSearch 2.4 configuration files from GitHub to $abs_dir..."
    mkdir -p "$abs_dir"
    curl -sSL https://raw.githubusercontent.com/sleede/fab-manager/master/setup/elasticsearch.yml > "$abs_dir/elasticsearch.yml"
    curl -sSL https://raw.githubusercontent.com/sleede/fab-manager/master/setup/log4j2.properties > "$abs_dir/log4j2.properties"
  fi
  docker-compose pull elasticsearch
  docker-compose up -d
  wait_for_online
  wait_for_green_status
  # check status
  local version=$(test_version)
  if [ "$STATUS" = "ONLINE" ] && [ "$version" = "$target" ]; then
    echo "Installation of elasticsearch $target was successful."
  else
    echo "Unable to find an active ElasticSearch $target instance, something may have went wrong, exiting..."
    echo "status: $STATUS, version: $version"
    exit 4
  fi
}

reindex_indices()
{
  # get number of documents (before elastic 5.x, docs.count is at column 6)
  local docs=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{s+=$6} END {printf "%.0f", s}')
  # get all indices
  local indices=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{print $3}')

  local migration_indices=""
  for index in $indices # do not surround $indices with quotes
  do
    # get the mapping of the existing index
    local mapping=$(curl "http://$ES_IP:9200/$index/_mapping" 2>/dev/null | jq -c -M -r ".$index")
    local definition=$(echo "$mapping" '{
      "settings" : {
        "index" : {
          "number_of_shards": 1,
          "number_of_replicas": 0,
          "refresh_interval": -1
        }
      }
    }' | jq -s add)
    local migration_index="$index""_$1"
    migration_indices+="$migration_index,"
    # create the temporary migration index with the previous mapping
    curl -XPUT "http://$ES_IP:9200/$migration_index/" 2>/dev/null -H 'Content-Type: application/json' -d "$definition"
    # reindex data content to the new migration index
    curl -XPOST "$ES_IP:9200/_reindex?pretty" 2>/dev/null -H 'Content-Type: application/json' -d '{
      "source": {
        "index": "'"$index"'"
      },
      "dest": {
        "index": "'"$migration_index"'"
      },
      "script": {
        "inline": "ctx._source.remove('"'"'_id'"'"')"
      }
    }'
  done
  echo "Indices are reindexing. This may take a while, waiting to finish... "
  # first we wait for all indices states became green
  wait_for_green_status
  # then we wait for all documents to be reindexed
  local new_docs=$(curl "$ES_IP:9200/_cat/indices?index=$migration_indices" 2>/dev/null | awk '{s+=$6} END {printf "%.0f", s}')
  while [ "$new_docs" != "$docs" ]
  do
    echo -ne "\rdocs: $docs, reindexed: $new_docs"
    sleep 1
    new_docs=$(curl "$ES_IP:9200/_cat/indices?index=$migration_indices" 2>/dev/null | awk '{s+=$6} END {printf "%.0f", s}')
  done
  echo -e "\nReindex completed, deleting previous index..."
  for index in $indices # do not surround $indices with quotes
  do
    curl -XDELETE "$ES_IP:9200/$index?pretty" 2>/dev/null
  done
  reenable_allocation
}

reindex_final_indices()
{
  local previous=$1
  # get number of documents (from elastic 5.x, docs.count is at column 7)
  local docs=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{s+=$7} END {printf "%.0f", s}')
  # get all indices
  local indices=$(curl "$ES_IP:9200/_cat/indices" 2>/dev/null | awk '{print $3}')

  local final_indices=""
  for index in $indices # do not surround $indices with quotes
  do
    # get the mapping of the existing index
    local mapping=$(curl "http://$ES_IP:9200/$index/_mapping" 2>/dev/null | jq -c -M -r ".$index")
    local definition=$(echo "$mapping" '{
      "settings" : {
        "index" : {
          "number_of_shards": 1,
          "number_of_replicas": 0,
          "refresh_interval": -1
        }
      }
    }' | jq -s add)
    local final_index=$(echo "$index" | sed "s/\(.*\)_$previous$/\1/")
    final_indices+="$final_index,"
    # create the final index with the previous mapping
    curl -XPUT "http://$ES_IP:9200/$final_index" 2>/dev/null -H 'Content-Type: application/json' -d "$definition"
    # reindex data content to the new migration index
    curl -XPOST "$ES_IP:9200/_reindex?pretty" 2>/dev/null -H 'Content-Type: application/json' -d '{
      "source": {
        "index": "'"$index"'"
      },
      "dest": {
        "index": "'"$final_index"'"
      }
    }'
  done
  echo "Indices are reindexing. This may take a while, waiting to finish... "
  # first we wait for all indices states became green
  wait_for_green_status
  # then we wait for all documents to be reindexed
  local new_docs=$(curl "$ES_IP:9200/_cat/indices?index=$final_indices" 2>/dev/null | awk '{s+=$7} END {printf "%.0f", s}')
  while [ "$new_docs" != "$docs" ]
  do
    echo -ne "\rdocs: $docs, reindexed: $new_docs"
    sleep 1
    new_docs=$(curl "$ES_IP:9200/_cat/indices?index=$final_indices" 2>/dev/null | awk '{s+=$7} END {printf "%.0f", s}')
  done
  echo -e "\nReindex completed, deleting previous index..."
  for index in $indices # do not surround $indices with quotes
  do
    curl -XDELETE "$ES_IP:9200/$index?pretty" 2>/dev/null
  done
  reenable_allocation
}

function trap_ctrlc()
{
  echo "Ctrl^C, exiting..."
  exit 2
}

upgrade_elastic()
{
  config
  detect_installation
  read -rp "Continue with upgrading? (y/n) " confirm </dev/tty
  if [[ "$confirm" = "y" ]]; then
    trap "trap_ctrlc" 2 # SIGINT
    ensure_initial_status_green
    upgrade_compose '1.7' '2.4'
    reindex_indices '24'
    upgrade_compose '2.4' '5.6'
    reindex_final_indices '24'
  fi
}

upgrade_elastic "$@"
