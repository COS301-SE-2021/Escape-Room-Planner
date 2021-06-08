class CreateContainerRequest

  attr_accessor :name, :posx, :posy, :width, :height, :graphicid, :nextV, :estimatedTime, :description, :roomID

  def initialize
    @name = nil
    @posx = nil
    @posy = nil
    @width = nil
    @height = nil
    @graphicid = nil
    @nextV = nil
    @estimatedTime = nil
    @description = nil
    @roomID = nil
  end

end
