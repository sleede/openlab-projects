### DB CREATE

```bash
docker run --rm \
           --link=openlab-postgres:postgres \
           --link=openlab-redis:redis \
           --link=openlab-elastic:elasticsearch \
           -e RAILS_ENV=production \
           --env-file /home/core/openlab/config/env \
           sleede/openlab-projects \
           bundle exec rake db:create
```

### DB MIGRATE

```bash
docker run --rm \
           --link=openlab-postgres:postgres \
           --link=openlab-redis:redis \
           --link=openlab-elastic:elasticsearch \
           -e RAILS_ENV=production \
           --env-file /home/core/openlab/config/env \
           sleede/openlab-projects \
           bundle exec rake db:migrate
```

### DB SEED

```bash
docker run --rm \
           --link=openlab-postgres:postgres \
           --link=openlab-redis:redis \
           --link=openlab-elastic:elasticsearch \
           -e RAILS_ENV=production \
           --env-file /home/core/openlab/config/env \
           sleede/openlab-projects \
           bundle exec rake db:seed
```

### BUILD ASSETS

```bash
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

# PREPARE ELASTIC
```bash
docker run --rm \
             --link=openlab-postgres:postgres \
             --link=openlab-redis:redis \
             --link=openlab-elastic:elasticsearch \
             -e RAILS_ENV=production \
             --env-file /home/core/openlab/config/env \
             sleede/openlab-projects \
             bundle exec rake openlab:elastic:setup
```

### RUN APP

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
             sleede/openlab-projects
```
