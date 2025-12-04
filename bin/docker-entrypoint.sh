#!/usr/bin/env bash
set -e

# Wait for Postgres
if [[ -n "${DATABASE_URL}" ]]; then
  echo "Waiting for database at ${DATABASE_URL}..."
  until bundle exec ruby -e "require 'uri'; u=URI(ENV['DATABASE_URL']); require 'pg'; PG.connect(host: u.host, port: u.port || 5432, dbname: u.path.delete_prefix('/'), user: u.user, password: u.password).close" >/dev/null 2>&1; do
    sleep 1
  done
fi

# Install gems if mounted volume is empty
bundle check || bundle install

# Setup DB for non-prod
if [[ "${RAILS_ENV}" != "production" ]]; then
  bundle exec rake db:create db:migrate
fi

exec "$@"
