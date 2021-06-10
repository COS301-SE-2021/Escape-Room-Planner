class ResetRoomRequest
  attr_accessor :auth, :room_id

  def initialize(auth, room_id)
    @auth = auth
    @room_id = room_id
  end
end