require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'

class SolvabilityService


  def calculate_solvability(request)

    raise 'Solvability Request cant be null' if request.nil?

    if request.startVert.nil? || request.endVert.nil? || request.vertices.nil?
      raise 'Parameters in request object cannot be null'
    end

    CalculateSolvableResponse.new(detect_cycle(request))

  end

  def calculate_set_up_order(request)

    raise 'Solvability Request cant be null' if request.nil?

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
    edges = []
    edge_count = 0
    puts
    i = 0
    while i < request.vertices.count
      vert = Vertex.find_by(id: request.vertices[i])
      to_vertex = vert.vertices.all

      # for each vertex find edges

      to_vertex.each do |to|
        edges[edge_count] = "#{request.vertices[i]},#{to.id}"
        puts "num: #{edge_count} edge: #{edges[edge_count]}"
        edge_count += 1
      end

      i += 1
    end

    # check legal moves
    i = 0
    while i < edge_count
      from_vert_id = edges[i].partition(',').first
      to_vertex_id = edges[i].partition(',').last

      # if key or clue(Item)
      # can only interact with puzzle
      if Vertex.find_by(id: from_vert_id).type == key_const || Vertex.find_by(id: from_vert_id).type == clue_const
        if Vertex.find_by(id: to_vertex_id).type != puzzle_const
          puts "Error occurred at #{from_vert_id} #{to_vertex_id} because clue not to puzzle"
          return false
        end
      end

      # if container
      # has to go to key or clue
      if Vertex.find_by(id: from_vert_id).type == container_const
        if Vertex.find_by(id: to_vertex_id).type == puzzle_const
          puts "Error occurred at #{from_vert_id} #{to_vertex_id} because container not to clue or key"
          return false
        end
      end

      # if puzzle
      # has to go to container
      if Vertex.find_by(id: from_vert_id).type == puzzle_const
        if Vertex.find_by(id: to_vertex_id).type != container_const
          puts "Error occurred at #{from_vert_id} #{to_vertex_id} because puzzle not to container"
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
    vert = Vertex.find_by(id:start_node)
    puts "current node is: #{vert.id}"

    @found = true if vert.id == @end_node

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
               end

    end
    @found
  end


end
