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

  def createClue(request)

    if request == nil
      return CreateClueResponse.new(-1, false)
    end


    @clue = Clue.new
    @clue.name = request.name
    @clue.posx = request.posx
    @clue.posy = request.posy
    @clue.width = request.width
    @clue.height = request.height
    @clue.graphicid = request.graphicid
    @clue.clue = request.clue
    @clue.escape_room_id = request.roomID

    @response = if @clue.save
                  CreateClueResponse.new(@clue.id, true)
                else
                  CreateClueResponse.new(-1, false)
                end

  end
  
end