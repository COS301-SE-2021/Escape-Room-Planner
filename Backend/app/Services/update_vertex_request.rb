# frozen_string_literal: true

# Update Vertex Request for transformation requests to vertex
class UpdateVertexRequest
  attr_accessor :id, :pos_x, :pos_y, :width, :height, :z_index

  def initialize(id, pos_x, pos_y, width, height, z_index)
    @id = id
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
    @z_index = z_index
  end
end
