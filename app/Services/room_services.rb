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

  def createContainer(request)
    if (request == nil)
      raise 'CreateContainerRequest null'
    end

    @container = Container.new
    @container.posx = request.posx
    @container.posy = request.posy
    @container.width = request.width
    @container.height = request.height
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
    if vertex == nil
      @response = RemoveVertexResponse.new(false)
      @response.message = "Could not find vertex"
    else
      vertex.delete
      @response = RemoveVertexResponse.new(true)
    end
    @response
  end

end