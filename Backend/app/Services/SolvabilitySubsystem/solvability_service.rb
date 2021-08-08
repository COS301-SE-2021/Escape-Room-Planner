class SolvabilityService

  def calculate_solvability(request)

    raise 'Solvability Request cant be null' if request.nil?

    if request.startVert.nil? || request.endVert.nil || request.vertices.nil?
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

    # Two arrays of size of num vertices set to false
    visited = Array.new(request.vertices.count)

    # For each vertex in the array
    while i<request.vertices
      i = 0
      while i < visited.count
        visited[i] = false
        inc(i)
      end
    end



    false
  end

  def cyclic(index, visited, stack)
    # if node has been stack or visited return true
    return true if stack[index]

    return true if visited[index]

    # set current node to visited and stack
    visited[index] = true

    stack[index] = true

    # create array with


  end

  end
