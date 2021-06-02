class RoomServices

   def createEscapeRoom(request)
      @escapeRoom = EscapeRoom.new
      @escapeRoom.save
      @response = CreateEscaperoomResponse.new(@escapeRoom.id)
      @response
   end

end