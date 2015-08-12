source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails', '4.2.3'

gem 'configatron'
gem 'data_migrate'
gem 'draper'
gem 'pg'
gem 'newrelic_rpm'

gem 'faye'

gem 'devise'
gem 'cancancan', '~> 1.10'
gem 'rolify'

gem 'roo'
gem 'roo-xls'

gem 'slim'

gem 'kaminari'
gem 'simple_form'

# assets

gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'

gem 'turbolinks'

gem 'jquery-datatables-rails'
gem 'ajax-datatables-rails'

gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-timepicker-rails'
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails'
gem 'breadcrumbs_on_rails'
gem 'nprogress-rails'

# CUSTOM JS
gem 'sweet-alert'
gem 'sweet-alert-confirm'

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap3-calendar'
end

group :development do
  gem 'quiet_assets'
  gem 'capistrano', '2.15.5', require: false
  gem 'capistrano-rbenv', '1.0.5', require: false
  gem 'byebug'
  gem 'spring'
  gem 'thin'
  gem 'web-console'
end

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
end

group :production do
  gem 'dalli'
  gem 'memcachier'
end

group :production, :staging do
  gem 'rollbar'
end
