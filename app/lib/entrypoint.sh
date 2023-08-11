#!/bin/sh
# https://stackoverflow.com/a/38732187/1935918
# https://stackoverflow.com/questions/38089999/docker-compose-rails-best-practice-to-migrate
set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

bundle exec rake db:migrate 2>/dev/null

exec bundle exec "$@"