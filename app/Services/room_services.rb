class RoomServices

   def createEscapeRoom(request)

      if  request == nil
         raise "CreateEscaperoomRequest null"
      end

      @escapeRoom = EscapeRoom.new
      @escapeRoom.save
      @response = CreateEscaperoomResponse.new(@escapeRoom.id)
      @response

   end

end