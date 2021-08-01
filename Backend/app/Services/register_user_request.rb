class RegisterUserRequest
  attr_accessor :username, :password_digest, :email, :isAdmin

  def initialize(username, password_digest, email, isAdmin)
    @username = username
    @password_digest = password_digest
    @email = email
    @isAdmin = isAdmin
  end
end

