# Base image: Ruby compatible with Rails 4.2
FROM ruby:2.6-slim

# Install OS dependencies
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       nodejs \
       git \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Install bundler compatible with older Rails
RUN gem install bundler -v "~>1.17" --no-document

# Cache Gem installs
COPY Gemfile Gemfile.lock* /app/
RUN bundle _1.17.3_ install --jobs=4 --retry=3 --without development test

# Copy application source
COPY . /app

# Precompile assets (if RAILS_ENV=production)
ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}
RUN if [ "$RAILS_ENV" = "production" ]; then bundle exec rake assets:precompile; fi

# Expose port and set default command
EXPOSE 8084

# Use entrypoint to manage DB and start server
COPY bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle","exec","rails","server","-b","0.0.0.0","-p","8084"]
