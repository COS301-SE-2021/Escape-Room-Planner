# frozen_string_literal: true

class ResetPasswordNotificationResponse
  attr_accessor :success, :message

  def initialize(success, message)
    @success = success
    @message = message
  end
end
