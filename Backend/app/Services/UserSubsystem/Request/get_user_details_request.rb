# frozen_string_literal: true

class GetUserDetailsRequest
  attr_accessor :username, :password, :email

  def initialize(username, password, email)
    @username = username
    @password = password
    @email = email
  end
end
