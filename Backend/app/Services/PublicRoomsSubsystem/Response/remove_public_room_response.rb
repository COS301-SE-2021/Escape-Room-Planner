# frozen_string_literal: true

# response structure to know if room been removed from public
class RemovePublicRoomResponse
  attr_accessor :success, :message

  def initialize(success, message)
    @success = success
    @message = message
  end
end
