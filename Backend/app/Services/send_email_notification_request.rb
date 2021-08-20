# frozen_string_literal: true

class SendEmailNotificationRequest
  attr_accessor :mailer_type, :email

  def initialize(mailer_type, email)
    @mailer_type = mailer_type
    @email = email
  end
end
