class UpdateVertexRequest

  attr_accessor :id, :posx, :posy, :width, :height

  def initialize(id, posx, posy, width, height)
    @id = id
    @posx = posx
    @posy = posy
    @width = width
    @height = height
  end

end
