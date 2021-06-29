class SetAdminRequest
  attr_accessor :username, :email

  def initialize(username, email)
    @username = username
    @email = email
  end
end

