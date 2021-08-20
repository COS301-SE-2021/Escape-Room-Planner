# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

#email configuration

ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'gmail.com',
  authentication: 'plain',
  user_name: 'fivestack7@gmail.com',
  password: ENV.fetch('FIVE_STACK_EMAIL_PASSWORD', 'PASS')
}