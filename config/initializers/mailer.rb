ActionMailer::Base.default_url_options[:host] = configatron.host
ActionMailer::Base.smtp_settings = {
  address: 							configatron.smtp.address,
  port: 								configatron.smtp.port,
  domain: 							configatron.smtp.domain,
  user_name: 						configatron.smtp.user_name,
  password: 						configatron.smtp.password,
  authentication: 			configatron.smtp.authentication,
  enable_starttls_auto: true  
}