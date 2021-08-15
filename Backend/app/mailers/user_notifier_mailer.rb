class UserNotifierMailer < ApplicationMailer
  default from: 'fivestack7@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(email)
    mail(to: email,
         subject: 'test',
         body: 'HI')
  end
end
