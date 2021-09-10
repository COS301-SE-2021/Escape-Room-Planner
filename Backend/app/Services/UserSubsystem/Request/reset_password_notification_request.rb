# frozen_string_literal: true

class ResetPasswordNotificationRequest
  attr_accessor :email

  def initialize(email)
    @email = email
  end
end
