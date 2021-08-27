class GeneticAlgorithmRequest
  attr_accessor :vertices, :linear, :dead_nodes,room_id

  def initialize(vertices, linear, dead_nodes,room_id)
    @vertices = vertices
    @linear = linear
    @dead_nodes = dead_nodes
    @room_id = room_id
  end

end

