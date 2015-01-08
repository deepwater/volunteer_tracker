require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :stages, %w(staging production)
set :default_stage, "staging"
set :deploy_via, :remote_cache
set :keep_releases, 5
set :scm, :git

before  'bundle:install',  'rbenv:create_version_file'

after   'deploy:finalize_update', 'db:create_symlink'
after   'deploy:create_symlink', 'deploy:cleanup'