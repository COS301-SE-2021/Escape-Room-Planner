class RoomServices

   def createEscapeRoom(request)
      @escapeRoom = EscapeRoom.new
      @escapeRoom.save
      @response = CreateEscaperoomResponse.new(@escapeRoom.id)
      @response
   end

   def createClue(request)
      @clue = Clue.new(request.clue)
      @clue.save
      @response = CreateClueResponse.new(@clue.id)
      @response
   end
end