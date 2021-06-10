
class RoomServices

  def createPuzzle(request)

    raise 'CreatePuzzleRequest null' if request.nil?

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

    raise 'CreateEscaperoomRequest null' if request.nil?

    @escapeRoom = EscapeRoom.new
    @escapeRoom.save
    @response = CreateEscaperoomResponse.new(@escapeRoom.id)
    @response
  end

  def createKey(request)

    return CreateKeyResponse.new(-1, false) if request == nil

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
    raise 'CreateContainerRequest null' if request.nil?

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

  # @param [Object] request
  def remove_vertex(request)

    raise 'removeVertexRequest null' if request.nil?

    vertex = Vertex.find_by_id(request.vertexID)

    @response = if vertex.nil?
                  RemoveVertexResponse.new(false, 'Vertex could not be found')
                else
                  vertex.destroy
                  RemoveVertexResponse.new(true, 'Vertex has been removed with all links')
                end
  end

  def createClue(request)

    return CreateClueResponse.new(-1, false) if request == nil


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