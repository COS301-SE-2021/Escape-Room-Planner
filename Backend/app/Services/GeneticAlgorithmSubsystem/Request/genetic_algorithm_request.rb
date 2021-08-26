class CalculateEstimatedTimeRequest
  attr_accessor :vertices, :linear, :dead_nodes

  def initialize(vertices, linear, dead_nodes)
    @vertices = vertices
    @linear = linear
    @dead_nodes = dead_nodes
  end

end

