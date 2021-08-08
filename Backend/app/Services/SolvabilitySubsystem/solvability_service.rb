class SolvabilityService

  def calculate_solvability(request)

    raise 'Solvability Request cant be null' if request.nil?

    if request.startVert.nil? || request.endVert.nil || request.vertices.nil?
      raise 'Parameters in request object cannot be null'
    end

    CalculateSolvableResponse.new(solvabilityHelper(request.startVert, request.endVert, request.vertices))
  end

  def calculate_set_up_order(request)

    raise 'Solvability Request cant be null' if request.nil?

  end

  def calculate_estimated_time(request)

    raise 'Solvability Request cant be null' if request.nil?

  end

  def solvability_helper(startVert,endVert,vertices)
    @response = false
  end

  def detect_cycle()

    #Two arrays of size of num vertices set to false
    visited = Array.new
    restack = Array.new

    i = 0
    while i < visited.count

    end

  end

  def is_cyclic(i,visited,restack)
    if restack[i]
      return true
    end

    if visited[i]
      return true
    end




  end

  end
