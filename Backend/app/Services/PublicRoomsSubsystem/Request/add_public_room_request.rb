# frozen_string_literal: true

# request structure to know if public
class AddPublicRoomRequest
  attr_accessor :token, :room_id

  def initialize(token, room_id)
    @token = token
    @room_id = room_id
  end
end
