class CalculateSolvableRequest
  attr_accessor :startVert , :endVert, :vertices

  def initialize(start_vert, end_vert, vertices)
    @startVert = start_vert
    @endVert = end_vert
    @vertices = vertices
  end

end
