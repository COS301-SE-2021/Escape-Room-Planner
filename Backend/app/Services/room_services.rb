class RoomServices
  # @param [CreatePuzzleRequest] request
  # @return [CreatePuzzleResponse]
  def create_puzzle(request)
    raise 'CreatePuzzleRequest null' if request.nil?

    @puzzle = Puzzle.new
    @puzzle.name = request.name
    @puzzle.posx = request.pos_x
    @puzzle.posy = request.pos_y
    @puzzle.width = request.width
    @puzzle.height = request.height
    @puzzle.graphicid = request.graphic_id
    @puzzle.estimatedTime = request.estimated_time
    @puzzle.description = request.description
    @puzzle.escape_room_id = request.room_id

    @response = if @puzzle.save
                  CreatePuzzleResponse.new(@puzzle.id, true)
                else
                  CreatePuzzleResponse.new(nil, false)
                end
  end

  def create_escape_room(request)
    raise 'CreateEscapeRoomRequest null' if request.nil?

    @escape_room = EscapeRoom.new(name: request.name)
    @response = if @escape_room.save
                  CreateEscapeRoomResponse.new(@escape_room.id, @escape_room.name)
                else
                  CreateEscapeRoomResponse.new(nil, nil)
                end
  end

  def create_key(request)
    return CreateKeyResponse.new(nil, false) if request.nil?

    @key = Keys.new
    @key.name = request.name
    @key.posx = request.pos_x
    @key.posy = request.pos_y
    @key.width = request.width
    @key.height = request.height
    @key.graphicid = request.graphic_id
    @key.escape_room_id = request.room_id

    @response = if @key.save
                  CreateKeyResponse.new(@key.id, true)
                else
                  CreateKeyResponse.new(nil, false)
                end
  end

  # @param [CreateContainerRequest] request
  # @return [CreateContainerResponse]
  def create_container(request)
    raise 'CreateContainerRequest null' if request.nil?

    @container = Container.new
    @container.posx = request.pos_x
    @container.posy = request.pos_y
    @container.width = request.width
    @container.height = request.height
    @container.name = request.name
    @container.graphicid = request.graphic_id
    @container.escape_room_id = request.room_id

    @response = if @container.save
                  CreateContainerResponse.new(@container.id, true)
                else
                  CreateContainerResponse.new(nil, false)
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

  def disconnect_vertices(request)
    raise 'disconnect_vertices_request null' if request.nil?

    from_vertex = Vertex.find_by_id(request.from_vertex_id)
    return DisconnectVerticesResponse.new(false, 'From vertex could not be found') if from_vertex.nil?

    to_vertex = from_vertex.vertices.find_by_id(request.to_vertex_id)

    @response = if to_vertex.nil?
                  DisconnectVerticesResponse.new(false, 'There is no link between vertices')
                else
                  from_vertex.vertices.delete(request.to_vertex_id)
                  DisconnectVerticesResponse.new(true, 'Link has been removed')
                end
  end

  def create_clue(request)

    return CreateClueResponse.new(-1, false) if request.nil?

    @clue = Clue.new
    @clue.name = request.name
    @clue.posx = request.pos_x
    @clue.posy = request.pos_y
    @clue.width = request.width
    @clue.height = request.height
    @clue.graphicid = request.graphic_id
    @clue.clue = request.clue
    @clue.escape_room_id = request.room_id

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
                  ResetEscapeRoomResponse.new(false, 'Authorization failed')
                elsif Vertex.destroy_by(escape_room_id: request.room_id).nil?
                  ResetEscapeRoomResponse.new(true, 'The room is already empty, but I cleaned it again <3')
                else
                  ResetEscapeRoomResponse.new(true, 'The room has been reset to default state')
                end
  end

  # @param [UpdateVertexRequest] request
  # @return [UpdateVertexResponse]
  def update_vertex(request)
    raise 'Request null' if request.nil?

    vertex = Vertex.find_by_id(request.id)
    return UpdateVertexResponse.new(false, 'Vertex could not be found') if vertex.nil?

    vertex.posx = request.posx
    vertex.posy = request.posy
    vertex.width = request.width
    vertex.height = request.height

    @response = if vertex.save
                  UpdateVertexResponse.new(true, 'Vertex Updated')
                else
                  UpdateVertexResponse.new(false, 'Vertex Update parameters not working')
                end
  end
end
