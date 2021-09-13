# frozen_string_literal: true

class VerifyAccountRequest
  attr_accessor :verify_token

  def initialize(verify_token)
    @verify_token = verify_token
  end
end
