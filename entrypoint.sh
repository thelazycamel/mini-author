#!/bin/sh

rm -f tmp/pids/server.pid

bundle exec rails db:prepare
bundle exec puma -C config/puma.rb
