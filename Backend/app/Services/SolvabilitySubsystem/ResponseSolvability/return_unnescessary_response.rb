class ReturnUnnecessaryResponse
  attr_accessor :vertices,:error

  def initialize(vertices, error='no error')
    @vertices = vertices
    @error = error
  end


end

