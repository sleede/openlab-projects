# Upgrade from 1.0.3 to 1.1.0

- Change redis to v6-alpine in docker-compose.yml
- Add nginx to the docker-compose.yml and rename openlab-projects to openlab in nginx service
- Remove ports binding in service openlab, in docker-compose.yml
- Remove volumes `config/nginx` and `letsencrypt` in service openlab, in docker-compose.yml
- In `config/nginx/openlab.conf` change `upstream puma { server unix:/...; }` to `upstream puma { server openlab:3300; }`
- `docker-compose down && docker-compose up -d`
