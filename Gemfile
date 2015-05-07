source 'https://rubygems.org'

gem 'rails', '3.2.20'

gem 'configatron', '2.13.0'
gem 'data_migrate', '1.2.0'
gem 'draper', '0.18.0'
gem 'pg', '0.17.1'
gem 'newrelic_rpm', '3.7.1.182'

gem 'faye', '~> 1.0.3'

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
gem 'jquery-datatables-rails', '2.2.3'
gem 'ajax-datatables-rails', '0.2.0'

gem 'bootstrap-sass', '3.1.1.1'
gem 'bootstrap-datepicker-rails', '1.3.0.1'
gem 'bootstrap-timepicker-rails', '0.1.3'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.0.0'
gem 'breadcrumbs_on_rails', '2.3.0'

group :development do
  gem 'letter_opener', '1.2.0'
	gem 'capistrano', '2.15.5', require: false
	gem 'capistrano-rbenv', '1.0.5', require: false
	gem 'byebug', '3.5.1'
  gem 'thin', '1.5.1'
end

group :test do
  gem 'rspec-rails', '2.14.1'
  gem 'factory_girl_rails', '4.3.0'
  gem 'shoulda', '3.5.0'
  gem 'database_cleaner', '1.2.0'
  gem 'mocha', '1.0.0', require: 'mocha/setup'
end

group :production do
	gem 'dalli', '2.7.0'
	gem 'memcachier', '0.0.2'
end

group :production, :staging do
  gem 'rollbar', '0.12.15', require: 'rollbar/rails'
end

group :assets do
	gem 'sass-rails', '3.2.6'
	gem 'coffee-rails', '~> 3.2.1'
	gem 'uglifier', '>= 1.0.3'
	gem 'therubyracer', '0.12.1', platforms: :ruby, require: 'v8'
  gem 'turbo-sprockets-rails3', '0.3.11'
end
