class UserNotifierMailer < ApplicationMailer
  default from: 'fivestack7@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_reset_password_email(email)
      #sends reset password link to user's email
      mail(to: email,
           subject: 'Confirm Reset Password',
           body: 'http://localhost:4200/login')
  end

  def send_verify_account_email(email)
    mail(to: email,
         subject: 'Account Verification',
         body: 'Your account has been verified. add a verify account link that the user can select to verify account')
  end

  def send_test_email(email)
    mail(to: email,
         subject: 'test',
         body: 'HI')
  end
end
