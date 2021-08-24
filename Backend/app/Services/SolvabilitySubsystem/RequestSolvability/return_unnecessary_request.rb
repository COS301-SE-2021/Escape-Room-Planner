class ReturnUnnecessaryRequest
  attr_accessor :start_vert , :end_vert, :vertices

  def initialize(start_vert, end_vert, vertices)
    @start_vert = start_vert
    @end_vert = end_vert
    @vertices = vertices
  end

end

