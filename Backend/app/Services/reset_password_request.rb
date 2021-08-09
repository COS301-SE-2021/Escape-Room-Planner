class ResetPasswordRequest
  attr_accessor :username, :newPassword

  def initialize(username, newPassword)
    @username = username
    @newPassword = newPassword
  end
end
