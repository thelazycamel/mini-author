# Base image: Ruby 3.3
FROM ruby:3.3-slim

# Install OS dependencies
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       nodejs \
       npm \
       git \
    && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN npm install -g yarn

# Set workdir
WORKDIR /app

# Install bundler
RUN gem install bundler --no-document

# Cache Gem installs
COPY Gemfile Gemfile.lock /app/
RUN bundle install --jobs=4 --retry=3

# Copy application source
COPY . /app

# Install JS dependencies (Bootstrap/sass)
RUN yarn install

ENV RAILS_ENV=development

# Expose port
EXPOSE 8084

# Entrypoint
COPY bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD []
