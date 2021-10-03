# frozen_string_literal: true

class SetAdminRequest
  attr_accessor :username

  def initialize(username)
    @username = username
  end
end
