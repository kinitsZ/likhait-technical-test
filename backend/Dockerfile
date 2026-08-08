# syntax = docker/dockerfile:1

# Use Ruby 3.3.7
ARG RUBY_VERSION=3.3.7
FROM ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential ca-certificates default-mysql-client default-libmysqlclient-dev git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./

# Configure bundler and install gems with retry logic.
# Gems install into GEM_HOME (/usr/local/bundle), which docker-compose backs
# with a named volume. Setting a bundler `path` here would place them under
# /rails instead, where the source bind mount hides them at runtime.
RUN bundle config set --local deployment 'false' && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Entrypoint prepares the database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]