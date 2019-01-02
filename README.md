## README

### dev env

Prerequisites :
- RVM (see http://rvm.io/)
- ElasticSearch
- PostgreSQL
- Redis

#### Install ElasticSearch 1.7 with docker
```bash
docker run --restart=always -d --name openlab-elastic \
  -v /path.to.docker/openlab/elasticsearch/config:/usr/share/elasticsearch/config \
  -v /path.to.docker/openlab/elasticsearch:/usr/share/elasticsearch/data \
  -v /path.to.docker/openlab/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
  -v /path.to.docker/openlab/elasticsearch/backups:/usr/share/elasticsearch/backups \
  --network openlab --ip 172.19.0.2 \
  elasticsearch:1.7
```

#### Install Redis with docker
```bash
docker run --restart=always -d --name=openlab-redis \
  -v /path.to.docker/openlab/redis:/data \
  --network openlab --ip 172.19.0.3 \
  redis:3 redis-server --appendonly yes 
```

#### Setup PostgreSQL database
```bash
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

#### Install OpenLab-projects for development
```bash
gem install bundler
bundle
mkdir -p tmp/pids
cp config/database.yml.default config/database.yml
foreman s
```

### prod env

We use docker-compose to run the app in production.
See [docker/README.md](docker/README.md) for more details.
```bash
curl -sSL https://raw.githubusercontent.com/LaCasemate/openlab-projects/dockercompose/docker/docker-compose.yml > docker-compose.yml
curl -sSL https://raw.githubusercontent.com/LaCasemate/openlab-projects/dockercompose/docker/env.example > config/env
docker-compose pull
```

If any asset has changed, recompile them
```bash 
rm -rf public/assets/
docker-compose run --rm openlab-projects bundle exec rake assets:precompile
```

If the database has changed (migration) or any other change occurred, run the specific commands like the "asset precompile" one (eg. bundle exec rake db:migrate).

Finally restart the container
```bash
docker-compose down
docker-compose up -d
```

### command to test analyzers

```bash
 curl -XGET 'localhost:9200/openfablab_development/_analyze?analyzer=xxxxxx' -d "autre sport" | python -m json.tool
```
