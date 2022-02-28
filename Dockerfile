FROM ruby:2.7.4-bullseye
MAINTAINER team sleede <contact@sleede.com>

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && \
    apt-get install -y \
      nodejs \
      supervisor

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 --without dev

# Run Bundle in a cache efficient way
WORKDIR /tmp
COPY Gemfile /tmp/
COPY Gemfile.lock /tmp/

#RUN bundle install
RUN bundle install --binstubs

# web app directories
RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/config
RUN mkdir -p /usr/src/app/uploads
RUN mkdir -p /usr/src/app/log
RUN mkdir -p /usr/src/app/public/uploads
RUN mkdir -p /usr/src/app/public/assets
RUN mkdir -p /usr/src/app/tmp/sockets
RUN mkdir -p /usr/src/app/tmp/pids

# copy app
WORKDIR /usr/src/app
COPY . /usr/src/app

# database.yml
COPY docker/database.yml /usr/src/app/config/database.yml


# Volumes
VOLUME /usr/src/app/uploads
VOLUME /usr/src/app/public/uploads
VOLUME /usr/src/app/public/assets
VOLUME /var/log/supervisor

# Expose port 3300 to the Docker host, so we can access it from the outside.
EXPOSE 3300

# at container start:
# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
COPY docker/supervisor.conf /etc/supervisor/conf.d/openlab.conf
CMD ["/usr/bin/supervisord"]
