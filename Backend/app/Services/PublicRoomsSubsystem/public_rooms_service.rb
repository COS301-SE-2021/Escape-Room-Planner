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

  # adds public room such that all users can access
  def add_public_room(request)
    decoded_token = JsonWebToken.decode(request.token)
    if EscapeRoom.find_by_id(request.room_id).user_id == decoded_token['id']
      room = PublicRoom.new
      room.escape_room_id = request.room_id
      return AddPublicRoomResponse.new(true, 'Room set to public') if room.save!
    end
    AddPublicRoomResponse.new(false, 'Account not registered to room')
  rescue StandardError => e
    puts e
    AddPublicRoomResponse.new(false, 'Error occurred while setting room public')
  end

  # removes public room from database
  def remove_public_room(request)
    decoded_token = JsonWebToken.decode(request.token)
    if EscapeRoom.find_by_id(request.room_id).user_id == decoded_token['id']
      room = PublicRoom.find_by_escape_room_id(request.room_id)
      if room.nil?
        return AddPublicRoomResponse.new(false, 'Public room not found')
      elsif room.destroy
        return AddPublicRoomResponse.new(true, 'Room Removed')
      end
    end
    RemovePublicRoomResponse.new(false, 'Can not remove from public')
  rescue StandardError => e
    puts e
    AddPublicRoomResponse.new(false, 'Error occurred while removing public room')
  end

  def add_rating(request)
    return AddRatingResponse.new(false, 'Null Request') if request.nil?
    decoded_token = JsonWebToken.decode(request.token)

    @user_id = decoded_token['id']
    #check user actually exists
    return AddRatingResponse.new(false, 'User does not exit') if User.find_by_id(@user_id).nil?

    @rating = request.rating
    @room_id = request.room_id

    #check room exits in public room
    return AddRatingResponse.new(false, 'Public room does not exist') if PublicRoom.find_by_id(@room_id).nil?

    #check if update
    if RoomRating.find_by(user_id: @user_id, public_room_id: @room_id)
      @update_rating = RoomRating.find_by(user_id: @user_id, public_room_id: @room_id)
      @update_rating.update(rating: @rating)
      
      if @update_rating.save!
        AddRatingResponse.new(true, 'Rating Updated')
      else
        AddRatingResponse.new(false, 'Rating could not be updated')
      end
    else

      @room_rating = RoomRating.new
      @room_rating.rating = @rating
      @room_rating.user_id = @user_id
      @room_rating.public_room_id = @room_id

      if @room_rating.save!
        AddRatingResponse.new(true, 'Successfully added rating')
      else
        AddRatingResponse.new(false, 'Add rating unsuccessful')
      end
    end
  rescue JWT::ExpiredSignature
    AddRatingResponse.new(false, 'Token expired')
  rescue StandardError => e
    puts e
    AddRatingResponse.new(false, 'Standard Error')
  end
end
