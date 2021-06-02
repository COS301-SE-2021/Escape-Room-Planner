require 'CreateKeyResponse'
require 'CreateKeyRequest'


class RoomServices

   def createEscapeRoom(request)
      @escapeRoom = EscapeRoom.new
      @escapeRoom.save
      @response = CreateEscaperoomResponse.new(@escapeRoom.id)
      @response
   end

   def createKey(request)
      @key = key.new
      @key.save
      @response = CreateKeyResponse.new(@key.id)
      @response
   end

end