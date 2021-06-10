
class RoomServices

  def createPuzzle(request)

    if (request.nil?)
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

    if  request.nil?
      raise 'CreateEscaperoomRequest null'
    end

    @escapeRoom = EscapeRoom.new
    @escapeRoom.save
    @response = CreateEscaperoomResponse.new(@escapeRoom.id)
    @response
  end

  def createKey(request)

    if request == nil
      return CreateKeyResponse.new(-1, false)
    end

    @key = Keys.new
    @key.name = request.name
    @key.posx = request.posx
    @key.posy = request.posy
    @key.width = request.width
    @key.height = request.height
    @key.graphicid = request.graphicid
    @key.escape_room_id = request.roomID

    @response = if @key.save
                  CreateKeyResponse.new(@key.id, true)
                else
                  CreateKeyResponse.new(-1, false)
                end

  end

  def createContainer(request)
    if (request.nil?)
      raise 'CreateContainerRequest null'
    end

    @container = Container.new
    @container.posx = request.posx
    @container.posy = request.posy
    @container.width = request.width
    @container.height = request.height
    @container.name = request.name
    @container.graphicid = request.graphicid
    @container.escape_room_id = request.roomID

    @response = if @container.save
                  CreateContainerResponse.new(@container.id, true)
                else
                  CreateContainerResponse.new(-1, false)
                end
    # Return the response
    @response
  end

  def removeVertex(request)
    @response
    vertex = Vertex.find_by_id(request.vertexID)
    if vertex.nil?
      @response = RemoveVertexResponse.new(false, 'Vertex could not be found')
      @response.message = 'Could not find vertex'
    else
      vertex.vertices = []
      vertex.delete
      @response = RemoveVertexResponse.new(true, 'Vertex has been removed with all links')
    end
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

  def reset_room(request)
    raise 'Request null' if request.nil?

    # from request we will be able to authorize the user
    # from request we get the room id which to reset

    # do authentication here later

    @response = if request.auth.nil?
                  ResetRoomResponse(false, 'Authorization failed')
                elsif Vertex.destroy_by(escape_room_id: request.room_id).nil?
                  ResetRoomResponse(true, 'The room is already empty, but I cleaned it again <3')
                else
                  ResetRoomResponse(true, 'The room has been reset to default state')
                end
  end
end
