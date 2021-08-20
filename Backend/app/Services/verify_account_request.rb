# frozen_string_literal: true

class VerifyAccountRequest
  attr_accessor :username

  def initialize(username)
    @username = username
  end
end
