class RegisterUserRequest
  attr_accessor :username, :password, :email, :isAdmin

  def initialize(username, password, email, isAdmin)
    @username = username
    @password = password
    @email = email
    @isAdmin = isAdmin
  end
end

