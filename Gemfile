source 'https://rubygems.org'

gem 'rails', '3.2.19'

gem 'configatron', '2.13.0'
gem 'data_migrate'
gem 'draper', '0.18.0'
gem 'delayed_job_active_record', '0.4.4'
gem 'pg'
gem 'newrelic_rpm'

gem 'faye', '~> 1.0.3'

gem 'devise', '2.2.4'
gem 'cancan', '1.6.10'
gem 'rolify', '3.4.0'

gem 'slim', '2.0.2'

gem 'kaminari', '0.15.1'
gem 'simple_form', '2.1.1'

gem 'jquery-rails', '3.0.1'
gem 'jquery-ui-rails', '4.0.3'
gem 'jquery-datatables-rails', '2.2.3', github: 'rweng/jquery-datatables-rails', branch: 'master'
gem 'ajax-datatables-rails', '0.2.0'

gem 'bootstrap-sass', '3.1.1.1'
gem 'bootstrap-datepicker-rails', '1.3.0.1'
gem 'bootstrap-timepicker-rails', '0.1.3'
gem 'momentjs-rails', '>= 2.8.1'
gem 'bootstrap3-datetimepicker-rails', '~> 3.0.2'

group :development do
  gem 'letter_opener', '1.2.0'
	gem 'capistrano', '2.15.5', require: false
	gem 'capistrano-rbenv', require: false
	gem 'debugger'
  gem 'thin', '1.5.1'
end

group :development, :test do
  gem 'rspec-rails', '2.14.1'
end

group :test do
  gem 'factory_girl_rails', '4.3.0'
  gem 'shoulda', '3.5.0'
  gem 'database_cleaner', '1.2.0'
  gem 'mocha', '1.0.0', require: 'mocha/setup'
end

group :production do
	gem 'dalli'
	gem 'memcachier'
end

group :production, :staging do
  gem 'rollbar', require: 'rollbar/rails'
end

group :assets do
  gem 'sass', '3.2.15'
	gem 'sass-rails', '3.2.6'
  gem 'tilt', '1.4.1'
	gem 'coffee-rails', '~> 3.2.1'
	gem 'uglifier', '>= 1.0.3'
	gem 'therubyracer', platforms: :ruby, require: 'v8'
  gem 'turbo-sprockets-rails3'
end
