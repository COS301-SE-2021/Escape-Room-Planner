class SetAdminRequest
  attr_accessor :username, :password, :email, :name, :isAdmin

  def initialize(username, password, email, isAdmin, name)
    @username = username
    @password = password
    @email = email
    @isAdmin = isAdmin
    @name = name
  end
end

