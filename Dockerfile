# Start with an Ubuntu 14.04 image that has ruby 2.1.5
FROM litaio/ruby:2.1.5

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get -q -y install libpq-dev git
RUN gem install bundler

ADD Gemfile /Gemfile
ADD Gemfile.lock /Gemfile.lock

# Create a nonroot user and switch to it so that we can run bundle install
RUN /usr/sbin/useradd --create-home --home-dir /usr/local/nonroot --shell /bin/bash nonroot
RUN /usr/sbin/adduser nonroot sudo
RUN chown -R nonroot /usr/local/
RUN chown -R nonroot /usr/lib/
RUN chown -R nonroot /usr/bin/

USER nonroot

# Install gems
RUN bundle install

# switch back to root for the rest of the show
USER root

# Add the source dir
ADD . /toshi

# Copy the config template
ADD config/toshi.yml.example /toshi/config/toshi.yml

# Set up our working dir
WORKDIR /toshi

# Expose port 5000 of the container to the host
EXPOSE 5000 