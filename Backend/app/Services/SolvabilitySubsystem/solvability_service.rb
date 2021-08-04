class SolvabilityService

  def calculateSolvability(request)

    raise 'Solvability Request cant be null' if request.nil?

    if request.startVert.nil? || request.endVert.nil || request.vertices.nil?
      raise 'Parameters in request object cannot be null'
    end

    CalculateSolvableResponse.new(solvabilityHelper(request.startVert, request.endVert, request.vertices))
  end

  def calculateSetUpOrder(request)

    raise 'Solvability Request cant be null' if request.nil?

  end

  def calculateEstimatedTime(request)

    raise 'Solvability Request cant be null' if request.nil?

  end
  
  def solvabilityHelper(startVert,endVert,vertices)
    @response = false
  end
  
end
