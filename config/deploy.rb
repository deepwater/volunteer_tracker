require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rollbar/capistrano'
set :rollbar_token, 'POST_SERVER_ITEM_ACCESS_TOKEN'

set :stages, %w(staging production staging2 production2)
set :default_stage, "staging"
set :deploy_via, :remote_cache
set :keep_releases, 5
set :scm, :git
set :rollbar_token, '1772fa5c530143ee81ff5086c61474cf'

before  'bundle:install',  'rbenv:create_version_file'

after   'deploy:finalize_update', 'db:create_symlink'
after   'deploy:create_symlink', 'deploy:cleanup'
