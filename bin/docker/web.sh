bundle
rm tmp/pids/server.pid
bin/rake db:create
bin/rake db:migrate
yarn install
rake assets:precompile
bin/rails server -p 3000 -b '0.0.0.0'