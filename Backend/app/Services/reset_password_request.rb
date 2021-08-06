# frozen_string_literal: true

class ResetPasswordRequest
  attr_accessor :username, :new_password

  def initialize(username, new_password)
    @username = username
    @new_password = new_password
  end
end
