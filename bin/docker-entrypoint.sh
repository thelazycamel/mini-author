#!/bin/sh
set -e

# Remove stale PID file
rm -f tmp/pids/server.pid

# If arguments are passed (e.g., from docker compose run), execute them directly
if [ $# -gt 0 ]; then
  exec "$@"
fi

# Default startup: run migrations then start puma
echo "Running database migrations..."
bundle exec rails db:prepare

echo "Starting Puma on port 8084..."
exec bundle exec puma -C config/puma.rb
