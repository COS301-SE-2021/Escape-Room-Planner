# frozen_string_literal: true

class NotificationServices
  def send_email_notification(request)
    return SendEmailNotificationResponse.new(false, 'Request null') if request.nil?

    resp = UserNotifierMailer.send_signup_email(request.email).deliver
    puts resp
    SendEmailNotificationResponse.new(true, 'Email sent successfully')

    # @response = if
    #               return SendEmailNotificationResponse.new(true, 'Email sent successfully')
    #             else
    #               return SendEmailNotificationResponse.new(false, 'Email failed to send')
    #             end
  end
end
