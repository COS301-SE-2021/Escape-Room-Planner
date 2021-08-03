class UpdateVertexRequest
  attr_accessor :id, :pos_x, :pos_y, :width, :height

  def initialize(id, pos_x, pos_y, width, height)
    @id = id
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
  end
end
