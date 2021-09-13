# frozen_string_literal: true

class GetUserDetailsResponse
  attr_accessor :success, :message

  def initialize(success, message)
    @success = success
    @message = message
  end
end
