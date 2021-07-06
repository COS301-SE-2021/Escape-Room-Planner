class ResetPasswordRequest
  attr_accessor :username, :password, :newPassword

  def initialize(username, password, newPassword)
    @username = username
    @password = password
    @newPassword = newPassword
  end
end
