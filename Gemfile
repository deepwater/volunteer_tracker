source 'https://rubygems.org'

gem 'rails', '3.2.20'

gem 'configatron', '2.13.0'
gem 'data_migrate', '1.2.0'
gem 'draper', '2.1.0'
gem 'pg', '0.17.1'
gem 'newrelic_rpm', '3.7.1.182'

gem 'devise', '2.2.4'
gem 'cancan', '1.6.10'
gem 'rolify', '3.4.0'

gem 'roo', '~> 2.0.0'
gem 'roo-xls', '1.0.0'

gem 'slim', '2.0.2'

gem 'kaminari', '0.15.1'
gem 'simple_form', '2.1.1'

gem 'jquery-rails', '3.0.1'
gem 'jquery-ui-rails', '4.0.3'
gem 'jquery-datatables-rails', '3.3.0'
gem 'ajax-datatables-rails', '0.3.0'

gem 'bootstrap-sass', '3.1.1.1'
gem 'bootstrap-datepicker-rails', '1.3.0.1'
gem 'bootstrap-timepicker-rails', '0.1.3'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.0.0'
gem 'breadcrumbs_on_rails', '2.3.0'
gem 'puma'

# CUSTOM JS
gem 'sweet-alert' # Custom alerts
gem 'sweet-alert-confirm' # Override default Rails UJS confirms

group :development do
  gem 'letter_opener', '1.2.0'
	gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv', '~> 2.0' # required
  gem 'capistrano-rbenv-install', '~> 1.2.0'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
	gem 'byebug', '3.5.1'
  gem 'thin', '1.5.1'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.1'
end

group :test do
  gem 'factory_girl_rails', '4.5.0'
  gem 'capybara', '2.4.4'
  gem 'poltergeist', '1.6.0'
  gem 'database_cleaner', '1.4.1'
  gem 'ffaker', '2.0.0'
end

group :production do
	gem 'dalli', '2.7.0'
	gem 'memcachier', '0.0.2'
end

group :production, :staging do
  gem 'rollbar', '~> 1.2.7'
end

group :assets do
	gem 'sass-rails', '3.2.6'
	gem 'coffee-rails', '~> 3.2.1'
	gem 'uglifier', '>= 1.0.3'
	gem 'therubyracer'
  gem 'turbo-sprockets-rails3', '0.3.11'
end
