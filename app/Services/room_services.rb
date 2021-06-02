require 'CreateKeyResponse'
require 'CreateKeyRequest'


class RoomServices

   def createEscapeRoom(request)
      @escapeRoom = EscapeRoom.new
      @escapeRoom.save
      @response = CreateEscaperoomResponse.new(@escapeRoom.id)
      @response
   end

   #no request data so there's nothing to set
   def createKey(request)
      @key = Keys.new
      @key.save
      @response = CreateKeyResponse.new(@key.id)
      @response
   end

end