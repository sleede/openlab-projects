### DB CREATE

```bash
docker-compose run --rm openlab-projects bundle exec rake db:create
```

### DB MIGRATE

```bash
docker-compose run --rm openlab-projects bundle exec rake db:migrate
```

### DB SEED

```bash
docker-compose run --rm openlab-projects bundle exec rake db:seed
```

### BUILD ASSETS

```bash
docker-compose run --rm openlab-projects bundle exec rake assets:precompile

```

# PREPARE ELASTIC
```bash
docker-compose run --rm openlab-projects bundle exec rake openlab:elastic:setup
```

### RUN APP

```bash
docker-compose up -d
```
