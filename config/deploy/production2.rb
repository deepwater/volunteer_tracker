require 'capistrano-rbenv'

set :dns_name, "162.243.66.189"

set :application, "volunteer2"
set :repository,  "git@github.com:deepwater/volunteer_tracker.git"

role :web, dns_name                          # Your HTTP server, Apache/etc
role :app, dns_name                          # This may be the same as your `Web` server
role :db,  dns_name, primary: true           # This is where Rails migrations will run

set :deploy_to, "/data/#{application}"

set :rails_env, 'production'
set :branch, 'ggf_tracker_production'
set :use_sudo, false

set :user, 'ninja'
set :password, 'B8M6GCTwpPpgVx'
set :port, 22

set(:rbenv_ruby_version, '2.1.0')