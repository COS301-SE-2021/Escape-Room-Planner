class CreatePuzzleRequest

  attr_accessor :name, :posx, :posy, :width, :height, :graphicid, :estimatedTime, :description, :roomID
  
  def initialize(name, posx, posy, width, height, graphicid, escape_room_id)
    @name = name
    @posx = posx
    @posy = posy
    @width = width
    @height = height
    @graphicid = graphicid
    @estimatedTime = nil
    @description = nil
    @roomID = escape_room_id
  end

end
