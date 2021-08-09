class LoginResponse

  attr_accessor :success, :message, :token

  def initialize(success, message, token)
    @success = success
    @message = message
    @token = token
  end
end
