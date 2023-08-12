mkdir -p tmp/pids
rm -f tmp/pids/server.pid
bundle exec rake db:migrate
exec bundle exec puma -C config/puma.rb