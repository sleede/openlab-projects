## README

## Setup a development environment

1. Install RVM, with the ruby version specified in the [.ruby-version file](../.ruby-version).
   For more details about the process, please read the [official RVM documentation](http://rvm.io/rvm/install)

2.Install docker and docker-compose.
Your system may provide a pre-packaged version of docker in its repositories, but this version may be outdated.
Please refer to the [official docker documentation](https://docs.docker.com/engine/install/) to set up a recent version of docker.

3. Add your current user to the docker group, to allow using docker without `sudo`.

   ```bash
   # add the docker group if it doesn't already exist
   sudo groupadd docker
   # add the current user to the docker group
   sudo usermod -aG docker $(whoami)
   # restart to validate changes
   sudo reboot
   ```

4. Retrieve the project from Git

   ```bash
   git clone https://github.com/sleede/openlab-projects.git
   ```


5. Move into the project directory and install the docker-based dependencies.
   > ⚠ If you are using Mac OS X, you must *first* edit the docker-compose.yml to use port binding instead of ip-based binding.
   > This can be achieved by uncommenting the "port" directives and commenting the "networks" directives in the docker-compose.yml file.
   > The hosts file must be modified too, accordingly.

   > ⚠ `ERROR: Pool overlaps with other one on this address space`
   > In this case, you must modify the /etc/hosts and docker-compose.yml files to change the network from 172.19.y.z to 172.x.y.z, where x is a new unused network.

   ```bash
   cd openlab-projects
   cd .docker
   cat hosts | sudo tee -a /etc/hosts
   docker network create openlab
   cd -
   ```

6. Init the RVM instance and check it's correctly configured

   ```bash
   rvm current | grep -q `cat .ruby-version`@openlab && echo "ok"
   # Must print ok, otherwise try "rvm use"
   ```

7. Install bundler in the current RVM gemset

   ```bash
   gem install bundler
   ```

8. Install the required ruby gems

   ```bash
   bundle install
   ```

9. Create the default configuration file

   ```bash
   cp config/database.yml.default config/database.yml
   ```

10. Build the databases.

> **🛈 Please note**: Your password length must be between 8 and 72 characters, otherwise db:setup will be rejected. This is configured in [config/initializers/devise.rb](config/initializers/devise.rb)

   ```bash
   ADMIN_EMAIL='youradminemail' ADMIN_PASSWORD='youradminpassword' rails db:setup
   rails openlab:elastic:init_index
   ```

11. Create the pids folder used by Sidekiq. If you want to use a different location, you can configure it in [config/sidekiq.yml](config/sidekiq.yml)

   ```bash
   mkdir -p tmp/pids
   ```

12. Start the development web server

   ```bash
   foreman s
   ```

13. You should now be able to access your local development Fab-manager instance by accessing `http://localhost:3300` in your web browser.

14. You can log in as the default administrator using the credentials defined previously.

#### Emails

Access `http://localhost:3300/letter_opener` to see the emails received. 
This interface is available only in development.

### prod env

We use docker-compose to run the app in production.
See [docker/README.md](docker/README.md) for more details.
```bash
mkdir -p /apps/openlab-projects/config/nginx/ssl
cd /apps/openlab-projects
mkdir -p elasticsearch/config
curl -sSL https://raw.githubusercontent.com/sleede/openlab-projects/dev/docker/docker-compose.yml > docker-compose.yml
curl -sSL https://raw.githubusercontent.com/sleede/openlab-projects/dev/docker/env.example > config/env
curl -sSL https://raw.githubusercontent.com/sleede/openlab-projects/dev/docker/elasticsearch/config/elasticsearch.yml > elasticsearch/config/elasticsearch.yml
curl -sSL https://raw.githubusercontent.com/sleede/openlab-projects/dev/docker/elasticsearch/config/log4j2.properties > elasticsearch/config/log4j2.properties
curl -sSL https://raw.githubusercontent.com/sleede/openlab-projects/dev/docker/nginx.conf > config/nginx/nginx.conf
docker-compose pull
```

- Build the certificate with let's encrypt or copy an existing one on the server folder.
- Change the docker-compose.yml file accordingly to bind the certificate directory to the nginx service.
- Change the nginx configuration to use the certificate.

```bash
curl -sSL https://raw.githubusercontent.com/sleede/openlab-projects/dev/docker/nginx.ssl.conf > config/nginx/nginx.conf
```

- Restart nginx

If any asset has changed, recompile them
```bash 
rm -rf public/assets/
docker-compose run --rm openlab-projects bundle exec rake assets:precompile
```

If the database has changed (migration) or any other change occurred, run the specific commands like the "asset precompile" one (eg. bundle exec rake db:migrate).

Finally, restart the container
```bash
docker-compose down
docker-compose up -d
```

### tests

to run the test suite:
```bash
bundle exec rake test
```


### command to test analyzers

```bash
 curl -XGET 'localhost:9200/openfablab_development/_analyze?analyzer=xxxxxx' -d "autre sport" | python -m json.tool
```

