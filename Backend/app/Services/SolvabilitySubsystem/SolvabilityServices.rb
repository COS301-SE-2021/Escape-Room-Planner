require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_set_up_order_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_set_up_order_response'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/return_unnescessary_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/return_unnecessary_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/file_all_paths_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/find_all_paths_request'


class SolvabilityService


  def find_all_paths_service(request)
    raise 'Request cant be null' if request.start_vert.nil? || request.end_vert.nil?

    find_all_paths(request.start_vert, request.end_vert)
    FindAllPathsResponse.new(@possible_paths, '', 0, request.end_vert)
  end

  def calculate_solvability(request)

    raise 'Solvability Request cant be null' if request.nil?

    raise 'Parameters in request object cannot be null' if request.startVert.nil? || request.endVert.nil?

    @reason = 'No reason given'
    CalculateSolvableResponse.new(detect_cycle(request), @reason)

  end

  def calculate_set_up_order(request)
    return SetUpOrderResponse.new(nil, 'Solvability Request cant be null') if request.nil?


    if request.startVert.nil? || request.endVert.nil? || request.vertices.nil?
      return SetUpOrderResponse.new(nil, 'Parameters in request object cannot be null')
    end


    return SetUpOrderResponse.new(nil, 'Escape room needs to be solvable first') unless calculate_solvability(request)

    @visited = []
    @visited_count = 0
    @order_count = 0
    @order_array = []
    vertices = set_up_order_helper(request.startVert)

    return SetUpOrderResponse.new(nil, 'Failure') if @order_array.nil?

    SetUpOrderResponse.new(@order_array, 'Success')

  end

  def return_unnecessary_vertices(request)
    if request.start_vert.nil? || request.end_vert.nil?
      return ReturnUnnecessaryResponse.new(nil, 'Incorrect parameters')
    end

    @visited = []
    @visited_count = 0
    @vertices = []
    find_unnecessary_vertices(request)

    ReturnUnnecessaryResponse.new(@uslessVerts)

  end

  def calculate_estimated_time(request)
    raise 'Solvability Request cant be null' if request.nil?
    if request.start_vert.nil? || request.end_vert.nil?
      return CalculateEstimatedTimeResponse.new(nil, 'false')
    end


    @totalTime=0
    find_all_paths(request.start_vert, request.end_vert)

    @possible_paths.each do |path|
      while path.index(',')
        addVertexTime(path[0, path.index(',')])
        path = path[path.index(',')+1, path.length]
      end
      addVertexTime(path)
    end

  end

  def addVertexTime(id)

  end

  def detect_cycle(request)

    clue_const = 'Clue'
    key_const = 'Keys'
    puzzle_const = 'Puzzle'
    container_const = 'Container'

    # Get all edges
    @edges = []
    @edge_count = 0

    find_all_edges(request)

    # check legal moves
    i = 0
    while i < @edge_count
      from_vert_id = @edges[i].partition(',').first
      to_vertex_id = @edges[i].partition(',').last

      # if key or clue(Item)
      # can only interact with puzzle
      if Vertex.find_by(id: from_vert_id).type == key_const || Vertex.find_by(id: from_vert_id).type == clue_const
        if Vertex.find_by(id: to_vertex_id).type != puzzle_const
          @reason = "Error occurred at #{from_vert_id} #{to_vertex_id} because clue can only go to puzzle"
          return false
        end
      end

      # if container
      # has to go to key or clue
      if Vertex.find_by(id: from_vert_id).type == container_const
        if Vertex.find_by(id: to_vertex_id).type == puzzle_const
          @reason = "Error occurred at #{from_vert_id} #{to_vertex_id} because container can only go to keys/clues or containers"
          return false
        end
      end

      # if puzzle
      # has to go to container
      if Vertex.find_by(id: from_vert_id).type == puzzle_const
        if Vertex.find_by(id: to_vertex_id).type != container_const
          @reason = "Error occurred at #{from_vert_id} #{to_vertex_id} because puzzle can only go to container"
          return false
        end
      end
      i += 1
    end

    @found = false
    @end_node = request.endVert
    @visited = []
    @visited_count = 0
    traverse(request.startVert)
  end

  def traverse(start_node)
    vert = Vertex.find_by(id: start_node)
    # puts "current node is: #{vert.id}"

    @found = true if vert.id == @end_node

    return @found if vert.vertices.all.nil?

    to_vertex = vert.vertices.all
    to_vertex.each do |to|


      if @visited_count.zero?
        @visited[@visited_count] = to.id
        @visited_count += 1
        traverse(to)
      elsif !@visited.include? to.id
        @visited[@visited_count] = to.id
        @visited_count += 1
        traverse(to)
      else
        @reason = 'Cycle detected'
               end

    end
    @found
  end

  def set_up_order_helper(start_node)
    vert = Vertex.find_by(id: start_node)

    to_vertex = vert.vertices.all
    @order_array[@order_count] = vert.id

    @order_count += 1

    to_vertex.each do |to|

      if @visited_count.zero?
        @visited[@visited_count] = to.id
        @visited_count += 1
        set_up_order_helper(to)
      elsif !@visited.include? to.id
        @visited[@visited_count] = to.id
        @visited_count += 1
        set_up_order_helper(to)
      end

    end
  end

  def find_unnecessary_vertices(request)
    find_all_paths(request.start_vert, request.end_vert)

    all = Vertex.all.where(escape_room_id: request.room_id)
    icount = 0
    vertices = []
    vertexIndices = []
    all.each do |v|
      vertices[icount] = v.id
      vertexIndices[icount] = false
      icount += 1
    end

    @possible_paths.each do |path|
      vertices.each do |vert|
        if path.include? vert.to_s
          index = vertices.index(vert)
          vertexIndices[index] = true
        end
      end
    end

    @uslessVerts = []
    icount = 0
    vertexIndices.each do |v|
      if v == false
        @uslessVerts.push(vertices[icount])
      end
      icount += 1
    end
  end

  def find_all_edges(request)
    @edges = []
    @edge_count = 0

    i = 0
    while i < request.vertices.count
      vert = Vertex.find_by(id: request.vertices[i])
      to_vertex = vert.vertices.all

      # for each vertex find edges

      to_vertex.each do |to|
        @edges[@edge_count] = "#{request.vertices[i]},#{to.id}"
        # puts "num: #{edge_count} edge: #{edges[edge_count]}"
        @edge_count += 1
      end

      i += 1
    end
  end

  def find_all_paths(start_vert, dest_vert)
    @all_paths_visited = []
    @all_paths_visited_count = 0
    all_paths_list = []
    @possible_paths = []

    all_paths_list.push(start_vert)
    find_all_paths_util(start_vert, dest_vert, all_paths_list)
  end

  def find_all_paths_util(current , dest , all_paths_list)
    #if match found then no need to traverse to depth
    if current == dest
      return_string = ''
      all_paths_list.each do |s|
        return_string = "#{return_string}#{s.to_s},"

      end
      return_string = return_string[0..return_string.length - 2]



      @possible_paths.push(return_string)
      return
    end

    #mark current node
    @all_paths_visited[current] = true

    #Recur for all vertices adjacent to current
    vert = Vertex.find_by(id: current)
    to_vertex = vert.vertices.all

    to_vertex.each do |v|
      unless @all_paths_visited[v.id]

        all_paths_list.push(v.id)

        find_all_paths_util(v.id, dest, all_paths_list)

        all_paths_list.delete(v.id)
      end
    end

    @all_paths_visited[current] = false
  end

end
