# frozen_string_literal: true

class LoginResponse
  attr_accessor :success, :message, :token, :username

  def initialize(success, message, token, username)
    @success = success
    @message = message
    @token = token
    @username = username
  end
end
