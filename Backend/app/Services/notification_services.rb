def send_email_notification(request)
  SendEmailNotificationResponse(false, 'SendEmailNotificationRequest null') if request.nil?
end
