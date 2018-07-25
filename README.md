## README

### dev env

```bash
gem install bundler
bundle
mkdir -p tmp/pids
cp config/database.yml.default config/database.yml
foreman s
```

### prod env

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
