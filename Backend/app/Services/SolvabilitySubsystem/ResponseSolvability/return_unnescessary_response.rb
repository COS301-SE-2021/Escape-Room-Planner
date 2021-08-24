class ReturnUnnecessaryResponse
  attr_accessor :vertices ,:error

  def initialize(vertices, error)
    @vertices = vertices
    @error = error
  end


end

