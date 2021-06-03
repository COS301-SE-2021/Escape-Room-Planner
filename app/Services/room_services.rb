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
    @puzzle.nextV = request.nextV
    @puzzle.estimatedTime = request.estimatedTime
    @puzzle.description = request.description
    @puzzle.escape_room_id = request.roomID
    
    if @puzzle.save
      @response = CreatePuzzleResponse.new(@puzzle.id, true)
    else
      @response = CreatePuzzleResponse.new(-1, false)
    end
    # Return the response
    @response
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

end