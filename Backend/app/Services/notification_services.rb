# frozen_string_literal: true

require 'mail'

class NotificationServices
  def send_email_notification(request)
    return SendEmailNotificationResponse(false, 'SendEmailNotificationRequest null') if request.nil?

    @mail = Mail.new do
      from 'alyak0803@gmail.com'
      to   'kayla.latty.kal@gmail.com'
      subject 'test email'
      body 'Hi this is a test'
    end

    @response = if @mail.deliver!
                  SendEmailNotificationResponse(true, 'email sent succesfully')
                else
                  SendEmailNotificationResponse(false, 'email unsuccessful')
                end
  end
end
