# frozen_string_literal: true

class ResetPasswordRequest
  attr_accessor :reset_token, :new_password

  def initialize(reset_token, new_password)
    @reset_token = reset_token
    @new_password = new_password
  end
end
