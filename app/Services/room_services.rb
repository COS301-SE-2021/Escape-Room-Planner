class RoomServices

   def createEscapeRoom(request)
      @escapeRoom = EscapeRoom.new
      @escapeRoomint = EscapeRoom.all.last.id
      @escapeRoom.id = @escapeRoomint += 1
      @escapeRoom.save
      @response = CreateEscaperoomResponse.new(@escapeRoom.id)
      @response
   end

end