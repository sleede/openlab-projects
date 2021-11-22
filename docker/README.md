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
   > ⚠ If you are using MacOS X, you must *first* edit the files located in docker/development to use port binding instead of ip-based binding.
   > This can be achieved by uncommenting the "port" directives and commenting the "networks" directives in the docker-compose.yml file.
   > The hosts file must be modified too, accordingly.

   > ⚠ `ERROR: Pool overlaps with other one on this address space`
   > In this case, you must modify the /etc/hosts and docker-compose.yml files to change the network from 172.19.y.z to 172.x.y.z, where x is a new unused network.

   ```bash
   cd openlab-projects
   cat docker/development/hosts | sudo tee -a /etc/hosts
   mkdir -p .docker/elasticsearch/config
   cp docker/development/docker-compose.yml .docker
   cp setup/elasticsearch.yml .docker/elasticsearch/config
   cp setup/log4j2.properties .docker/elasticsearch/config
   cd .docker
   docker network create openlab
   docker-compose up -d
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
   RAILS_ENV=test rails db:create
   RAILS_ENV=test rails db:migrate
   ```

11. Create the pids folder used by Sidekiq. If you want to use a different location, you can configure it in [config/sidekiq.yml](config/sidekiq.yml)

   ```bash
   mkdir -p tmp/pids
   ```

12. Start the development web server

   ```bash
   foreman s -p 3000
   ```

13. You should now be able to access your local development Fab-manager instance by accessing `http://localhost:3000` in your web browser.

14. You can log in as the default administrator using the credentials defined previously.

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
