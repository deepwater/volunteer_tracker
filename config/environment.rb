# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
VolunteerTracker::Application.initialize!


ActionMailer::Base.smtp_settings = {
    :port           => ENV['MAILGUN_SMTP_PORT'], 
    :address        => ENV['MAILGUN_SMTP_SERVER'],
    :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
    :password       => ENV['MAILGUN_SMTP_PASSWORD'],
    :domain         => 'secret-inlet-9787.heroku.com',
    :authentication => :plain,
  }
  
ActionMailer::Base.raise_delivery_errors = true

ActionMailer::Base.delivery_method = :smtp