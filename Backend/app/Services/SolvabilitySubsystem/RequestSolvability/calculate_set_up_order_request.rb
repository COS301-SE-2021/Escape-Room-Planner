class CalculateSetUpOrderRequest
  attr_accessor :startVert , :endVert, :vertices

  def initialize(startVert, endVert, vertices)
    @startVert = startVert
    @endVert = endVert
    @vertices = vertices
  end

end

