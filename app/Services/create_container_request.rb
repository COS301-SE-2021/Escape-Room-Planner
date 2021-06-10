class CreateContainerRequest

  attr_accessor :name, :posx, :posy, :width, :height, :graphicid, :roomID

  def initialize(posx, posy, width, height, graphicid, roomID, name)
    @posx = posx
    @posy = posy
    @width = width
    @height = height
    @graphicid = graphicid
    @roomID = roomID
    @name = name
  end

end
