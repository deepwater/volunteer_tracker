set :dns_name, "host.23stages.com"

set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

set :application, "volunteer"
set :repository,  "git@github.com:deepwater/volunteer_tracker.git"

role :web, dns_name                          # Your HTTP server, Apache/etc
role :app, dns_name                          # This may be the same as your `Web` server
role :db,  dns_name, primary: true           # This is where Rails migrations will run

set :deploy_to, "/data/#{application}"
set :deploy_via, :copy

set :rails_env, 'staging'
set :branch, 'master'
set :use_sudo, false

set :user, 'volunteer'
set :password, 'PQTUV6sdfyF2qm9'
set :port, 22

set(:rbenv_ruby_version, '2.1.5')