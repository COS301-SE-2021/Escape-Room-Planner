# frozen_string_literal: true

# response structure to know if room been set public
class AddPublicRoomResponse
  attr_accessor :success, :message, :data

  def initialize(success, message)
    @success = success
    @message = message
  end
end
