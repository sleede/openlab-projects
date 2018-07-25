## README

### dev env

Prerequisites :
- RVM
- ElasticSearch
- PostgreSQL
- Redis

```bash
gem install bundler
bundle
mkdir -p tmp/pids
cp config/database.yml.default config/database.yml
foreman s
```

### prod env

Get up-to-date docker image and remove the current running container
```bash
docker pull sleede/openlab-projects
docker rm -f openlab
```

If any asset has changed, recompile them
```bash 
rm -rf public/assets/
docker run --rm \
  --link=openlab-postgres:postgres \
  --link=openlab-redis:redis \
  --link=openlab-elastic:elasticsearch \
  -e RAILS_ENV=production \
  --env-file /home/core/openlab/config/env \
  -v /home/core/openlab/public/assets:/usr/src/app/public/assets \
  sleede/openlab-projects \
  bundle exec rake assets:precompile
```

If the database has changed (migration) or any other change occurred, run the specific commands like the "asset precompile" one (eg. bundle exec rake db:migrate).

Finally restart the container
```bash
docker run --restart=always -d --name=openlab \
  -p 80:80 \
  -p 443:443 \
  --link=openlab-postgres:postgres \
  --link=openlab-redis:redis \
  --link=openlab-elastic:elasticsearch \
  -e RAILS_ENV=production \
  -e RACK_ENV=production \
  --env-file /home/core/openlab/config/env \
  -v /home/core/openlab/config/nginx:/etc/nginx/conf.d \
  -v /home/core/openlab/public/assets:/usr/src/app/public/assets \
  -v /home/core/openlab/log:/var/log/supervisor \
  -v /home/core/openlab/letsencrypt/etc:/etc/letsencrypt \
  sleede/openlab-projects
```

### command to test analyzers

```bash
 curl -XGET 'localhost:9200/openfablab_development/_analyze?analyzer=xxxxxx' -d "autre sport" | python -m json.tool
```
