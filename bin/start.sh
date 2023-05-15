mkdir -p tmp/pids
rm -f tmp/pids/server.pid
exec bundle exec puma -C config/puma.rb