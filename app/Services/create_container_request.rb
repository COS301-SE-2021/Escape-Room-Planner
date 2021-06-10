class CreateContainerRequest

  attr_accessor :name, :posx, :posy, :width, :height, :graphicid, :roomID

  def initialize
    @posx = nil
    @posy = nil
    @width = nil
    @height = nil
    @graphicid = nil
    @roomID = nil
    @name = nil
  end

end
