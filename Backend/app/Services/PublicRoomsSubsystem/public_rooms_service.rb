# frozen_string_literal: true

# all services related to public rooms
class PublicRoomServices
  # will return all public rooms
  def public_rooms
    rooms = PublicRoom.all
    rating = RoomRating.group(:public_room_id).average(:rating)
    data = rooms.map do |room|
      escape_room = EscapeRoom.find_by_id(room.escape_room_id)
      username = User.find_by_id(escape_room.user_id).username
      { username: username,
        escape_room_id: room.escape_room_id,
        public_room_id: room.id,
        room_name: escape_room.name,
        rating: rating[room.id].to_f,
        best_time: room.best_time }
    end
    GetPublicRoomsResponse.new(true, 'Public Room Response', data)
  rescue StandardError => e
    puts e
    GetPublicRoomsResponse.new(false, 'Error occurred while getting Public Rooms', nil)
  end
end
