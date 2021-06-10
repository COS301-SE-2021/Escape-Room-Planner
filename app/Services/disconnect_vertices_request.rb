class DisconnectVerticesRequest
  attr_accessor :from_vertex_id, :to_vertex_id

  def initialize(from_vertex_id, to_vertex_id)
    @from_vertex_id = from_vertex_id
    @to_vertex_id = to_vertex_id
  end
end
