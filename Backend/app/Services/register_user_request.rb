# frozen_string_literal: true

class RegisterUserRequest
  attr_accessor :username, :password, :email, :is_admin

  def initialize(username, password, email, is_admin)
    @username = username
    @password = password
    @email = email
    @is_admin = is_admin
  end
end
