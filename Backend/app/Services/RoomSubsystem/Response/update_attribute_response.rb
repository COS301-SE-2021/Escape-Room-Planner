# frozen_string_literal: true

# Response for update vertices attribute service
class UpdateAttributeResponse
  attr_accessor :success, :message

  def initialize(success, message)
    @success = success
    @message = message
  end
end
