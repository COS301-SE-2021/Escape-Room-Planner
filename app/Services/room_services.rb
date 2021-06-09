
class RoomServices

  def createPuzzle(request)

    if (request == nil)
      raise 'CreatePuzzleRequest null'
    end

    @puzzle = Puzzle.new
    @puzzle.name = request.name
    @puzzle.posx = request.posx
    @puzzle.posy = request.posy
    @puzzle.width = request.width
    @puzzle.height = request.height
    @puzzle.graphicid = request.graphicid
    @puzzle.estimatedTime = request.estimatedTime
    @puzzle.description = request.description
    @puzzle.escape_room_id = request.roomID

    @response = if @puzzle.save
                  CreatePuzzleResponse.new(@puzzle.id, true)
                else
                  CreatePuzzleResponse.new(-1, false)
                end
  end

  def createEscapeRoom(request)

    if  request == nil
      raise "CreateEscaperoomRequest null"
    end

     @escapeRoom = EscapeRoom.new
     @escapeRoom.save
     @response = CreateEscaperoomResponse.new(@escapeRoom.id)
     @response

  end

   def createKey(request)

     if(request == nil )
       return CreateKeyResponse.new(-1, false)
     end

     @key = Keys.new(request.name,
                     request.posx,
                     request.posy,
                     request.width,
                     request.height,
                     request.graphicid,
                     request.roomID)

     if @key.save
       @response = CreateKeyResponse.new(@key.id, true)
     else
       @response = CreateKeyResponse.new(-1, false)
     end

     @response

   end

end