# frozen_string_literal: true

# Services for all operations on escape rooms and the vertices
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
    @puzzle.blob_id = request.blob_id

    @response = if @puzzle.save
                  CreatePuzzleResponse.new(@puzzle.id, true)
                else
                  CreatePuzzleResponse.new(nil, false)
                end
  end

  def create_escape_room(request)
    raise 'CreateEscapeRoomRequest null' if request.nil?

    decoded_token = JsonWebToken.decode(request.token)
    @escape_room = EscapeRoom.new(name: request.name, user_id: decoded_token['id'])
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
    @key.blob_id = request.blob_id

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
    @container.blob_id = request.blob_id unless request.blob_id.nil?
    @response = if @container.save
                  CreateContainerResponse.new(@container.id, true)
                else
                  CreateContainerResponse.new(nil, false)
                end
    # Return the response
  end

  # @param [RemoveVertexRequest] request
  # @return [RemoveVertexResponse]
  def remove_vertex(request)
    raise 'removeVertexRequest null' if request.nil?

    vertex = Vertex.find_by_id(request.vertex_id)

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
    @clue.blob_id = request.blob_id

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

  # @param [ConnectVerticesRequest] request
  # @return [ConnectVerticesResponse]
  def connect_vertex(request)
    raise 'Request null' if request.nil?

    from_vertex = Vertex.find_by_id(request.from_vertex_id)
    return ConnectVerticesResponse.new(false, 'From vertex could not be found') if from_vertex.nil?

    to_vertex = Vertex.find_by_id(request.to_vertex_id)
    return ConnectVerticesResponse.new(false, 'To vertex could not be found') if to_vertex.nil?

    num_vertices = from_vertex.vertices.count
    @response = if from_vertex.vertices.append(to_vertex).count < num_vertices
                  ConnectVerticesResponse.new(false, 'Link could not be established')
                else
                  ConnectVerticesResponse.new(true, 'Link has been established')
                end
  end

  # updates a Vertex transformation attributes
  # @param [UpdateVertexRequest] request
  # @return [UpdateVertexResponse]
  def update_vertex(request)
    raise 'Request null' if request.nil?

    vertex = Vertex.find_by_id(request.id)
    return UpdateVertexResponse.new(false, 'Vertex could not be found') if vertex.nil?

    vertex.posx = request.pos_x
    vertex.posy = request.pos_y
    vertex.width = request.width
    vertex.height = request.height
    vertex.z_index = request.z_index

    @response = if vertex.save
                  UpdateVertexResponse.new(true, 'Vertex Updated')
                else
                  UpdateVertexResponse.new(false, 'Incorrect Update Parameters')
                end
  end

  # @param [GetVerticesRequest] request
  # @return [GetVerticesResponse]
  def get_vertices(request)
    return GetVerticesResponse.new(false, 'Can not locate user', nil) if EscapeRoom.find_by_id(request.id).nil?

    vertices = Vertex.select(
      :id,
      :type,
      :name,
      :posx,
      :posy,
      :width,
      :height,
      :graphicid,
      :clue,
      :description,
      :estimatedTime,
      :blob_id,
      :z_index
    ).where(escape_room_id: request.id)
    return GetVerticesResponse.new(true, 'Room has no vertices', nil) if vertices.nil?

    escape_room = EscapeRoom.find_by_id(request.id)
    start_vertex_id = escape_room.startVertex
    end_vertex_id = escape_room.endVertex
    user = User.find_by_id(EscapeRoom.find_by_id(request.id).user_id)
    data = vertices.map do |k|
      pos = 'none'
      pos = 'start' if k.id == start_vertex_id
      pos = 'end' if k.id == end_vertex_id
      if (k.blob_id != 0) && !ActiveStorageBlobs.find_by_id(k.blob_id).nil?
        blob = user.graphic.blobs.find_by_id(k.blob_id)
        k.graphicid = Rails.application.routes.url_helpers.polymorphic_url(blob, host: ENV.fetch('BLOB_HOST',
                                                                                                 'localhost:3000'))
      end
      { vertex: k,
        connections: k.vertices.ids,
        type: k.type,
        position: pos }
    end
    # TODO: Fix to be more Efficient
    GetVerticesResponse.new(true, 'Vertices Obtained', data)
  rescue StandardError => e
    puts e
    GetVerticesResponse.new(false, 'Error occurred while getting Vertices', nil)
  end

  # @param [GetRoomsRequest] request
  # @return [GetRoomsResponse]
  def get_rooms(request)
    decoded_token = JsonWebToken.decode(request.token)
    user = User.find_by_id(decoded_token['id'])
    @response = if user.nil?
                  GetRoomsResponse.new(false, 'User can not be found', nil)
                else
                  public_room = EscapeRoom.joins(:public_room).where(user_id: decoded_token['id'])
                  data = EscapeRoom.select(:id, :name).where(user_id: decoded_token['id']).map do |room|
                    is_public = true
                    is_public = false if public_room.find_by(id: room.id).nil?
                    {
                      id: room.id,
                      name: room.name,
                      is_public: is_public
                    }
                  end
                  GetRoomsResponse.new(true, 'Rooms obtained', data)
                end
  rescue StandardError => e
    puts e
    GetRoomsResponse.new(false, 'Error occurred while getting Rooms', nil)
  end

  # updates vertex attributes
  # must have either name, clue, time, description of correct type to update
  # @param request of type UpdateAttributeRequest
  # @return UpdateVertexResponse object
  def update_attribute(request)
    flag = false

    vertex = Vertex.find_by_id(request.id)
    return UpdateAttributeResponse.new(false, 'Vertex id not valid') if vertex.nil?

    unless request.name.nil?
      vertex.name = request.name
      flag = true
    end
    unless request.time.nil?
      vertex.estimatedTime = request.time
      flag = true
    end

    unless request.clue.nil?
      vertex.clue = request.clue
      flag = true
    end
    unless request.description.nil?
      vertex.description = request.description
      flag = true
    end
    @response = if flag
                  if vertex.save
                    UpdateAttributeResponse.new(true, 'Vertex attributes updated')
                  else
                    UpdateAttributeResponse.new(false, 'Could not update vertex attribute')
                  end
                else
                  UpdateAttributeResponse.new(false, 'Incorrect vertex attributes given')
                end
  rescue StandardError => error
    puts error
    UpdateAttributeResponse.new(false, 'Error occurred while updating vertex attributes')
  end

  # get room images needed
  def room_images(request)
    room_images = RoomImage.select(
      :id,
      :pos_x,
      :pos_y,
      :width,
      :height,
      :blob_id
    ).where(escape_room_id: request.escape_room_id)

    return GetRoomImagesResponse.new(false, 'Could not get rooms', nil) if room_images.nil?

    user = User.find_by_id(EscapeRoom.find_by_id(request.escape_room_id).user_id)
    data = room_images.map do |k|
      blob_url = if (k.blob_id != 0) && !ActiveStorageBlobs.find_by_id(k.blob_id).nil?
                   Rails.application.routes.url_helpers.polymorphic_url(
                     user.graphic.blobs.find_by_id(k.blob_id), host: ENV.fetch('BLOB_HOST', 'localhost:3000')
                   )
                 else
                   './assets/images/room1.png'
                 end
      { room_image: k,
        src: blob_url }
    end
    GetRoomImagesResponse.new(true, 'Could not get rooms', data)
  rescue StandardError
    GetRoomImagesResponse.new(false, 'Could not get room images', nil)
  end
end
