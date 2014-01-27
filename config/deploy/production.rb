set :dns_name, "107.170.30.8"

set :application, "volunteer"
set :repository,  "git@github.com:omggroup/volunteer_tracker.git"

role :web, dns_name                          # Your HTTP server, Apache/etc
role :app, dns_name                          # This may be the same as your `Web` server
role :db,  dns_name, primary: true           # This is where Rails migrations will run

set :deploy_to, "/data/#{application}"

set :rails_env, 'production'
set :branch, 'master'
set :use_sudo, false

set :user, 'ninja'
set :password, 'B8M6GCTwpPpgVx'
set :port, 22