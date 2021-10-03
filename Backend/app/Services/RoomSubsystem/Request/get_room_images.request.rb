# frozen_string_literal: true

# Request for get room images service
class GetRoomImagesRequest
  attr_accessor :escape_room_id

  def initialize(escape_room_id)
    @escape_room_id = escape_room_id
  end
end
