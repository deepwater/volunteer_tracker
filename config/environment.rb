require 'csv'

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
VolunteerTracker::Application.initialize!


# ActionMailer::Base.smtp_settings = {
#   :address        => 'smtp.sendgrid.net',
#   :port           => '587',
#   :authentication => :plain,
#   :user_name      => ENV['SENDGRID_USERNAME'],
#   :password       => ENV['SENDGRID_PASSWORD'],
#   :domain         => 'heroku.com',
#   :enable_starttls_auto => true
# }

# ActionMailer::Base.raise_delivery_errors = true

# ActionMailer::Base.delivery_method = :smtp