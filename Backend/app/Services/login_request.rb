# frozen_string_literal: true

class LoginRequest
  attr_accessor :username, :password

  def initialize(username, password)
    @username = username
    @password = password
  end
end
