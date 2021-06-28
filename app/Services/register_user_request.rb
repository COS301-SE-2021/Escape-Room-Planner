class RegisterUserRequest
  attr_accessor :username, :password, :email, :name, :isAdmin

  def initialize(username, password, email, name, isAdmin)
    @username = username
    @password = password
    @email = email
    @name = name
    @isAdmin = isAdmin
  end
end

