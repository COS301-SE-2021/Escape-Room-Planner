# frozen_string_literal: true

class SendEmailNotificationRequest
  attr_accessor :email

  def initialize(email)
    @email = email
  end
end
