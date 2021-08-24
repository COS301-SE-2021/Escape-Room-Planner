require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_set_up_order_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_set_up_order_response'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/return_unnescessary_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/return_unnecessary_request'

class SolvabilityService


  def calculate_solvability(request)

    raise 'Solvability Request cant be null' if request.nil?

    if request.startVert.nil? || request.endVert.nil? 
      raise 'Parameters in request object cannot be null'
    end
    @reason = 'No reason given'
    CalculateSolvableResponse.new(detect_cycle(request),@reason)

  end

  def calculate_set_up_order(request)
    return SetUpOrderResponse.new(nil, 'Solvability Request cant be null') if request.nil?


    if request.startVert.nil? || request.endVert.nil? || request.vertices.nil?
      return SetUpOrderResponse.new(nil, 'Parameters in request object cannot be null')
    end


    unless calculate_solvability(request)
      return SetUpOrderResponse.new(nil, 'Escape room needs to be solvable first')
    end
    @visited = []
    @visited_count = 0
    @order_count = 0
    @order_array = []
    vertices = set_up_order_helper(request.startVert)

    return SetUpOrderResponse.new(nil, 'Failure') if @order_array.nil?

    SetUpOrderResponse.new(@order_array, 'Success')

  end

  def return_unnecessary_vertices(request)
    if request.start_vert.nil? || request.end_vert.nil? || request.vertices.nil?
      return ReturnUnnecessaryResponse.new(nil,'Incorrect parameters')
    end

    @visited = []
    @visited_count = 0
    @vertices = []
    find_unnecessary_vertices(request.startVert)

  end

  def calculate_estimated_time(request)

    raise 'Solvability Request cant be null' if request.nil?

  end

  # Create the graph using the given number of edges and vertices.
  # Create a recursive function that initializes the current index or vertex, visited, and recursion stack.
  # Mark the current node as visited and also mark the index in recursion stack.
  # Find all the vertices which are not visited and are adjacent to the current node. Recursively call the function for those vertices, If the recursive function returns true, return true.
  # If the adjacent vertices are already marked in the recursion stack then return true.
  # Create a wrapper class, that calls the recursive function for all the vertices and if any function returns true return true. Else if for all vertices the function returns false return false.

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

    if vert.vertices.all.nil?
      return @found
    end

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

  def find_unnecessary_vertices(start_node)

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
end
