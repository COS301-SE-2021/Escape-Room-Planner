# frozen_string_literal: true

class NotificationServices
  def send_email_notification(request)
    return SendEmailNotificationResponse.new(false, 'Request null') if request.nil?

    return SendEmailNotificationResponse.new(false, 'Mailer type not provided') if request.mailer_type.nil?

    return SendEmailNotificationResponse.new(false, 'Email does not exist') unless User.find_by_email(request.email)

    case request.mailer_type
    when 'verifyAccount'
      puts UserNotifierMailer.send_verify_account_email(request.email).deliver
      SendEmailNotificationResponse.new(true, 'Email sent successfully')
    when 'resetPassword'
      puts UserNotifierMailer.send_reset_password_email(request.email).deliver
      SendEmailNotificationResponse.new(true, 'Email sent successfully')
    when 'testEmail'
      puts UserNotifierMailer.send_test_email(request.email).deliver
      SendEmailNotificationResponse.new(true, 'Email sent successfully')
    else
      SendEmailNotificationResponse.new(false, 'Notifier type does not exist')
    end
  end
end
