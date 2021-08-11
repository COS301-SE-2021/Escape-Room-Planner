class ResetPasswordRequest
  attr_accessor :username, :password, :new_password

  def initialize(username, password, new_password)
    @username = username
    @new_password = new_password
    @password = password
  end
end
