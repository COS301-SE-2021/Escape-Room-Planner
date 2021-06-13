class CreatePuzzleRequest

  attr_accessor :name, :posx, :posy, :width, :height, :graphicid, :estimatedTime, :description, :roomID
  
  def initialize(name, posx, posy, width, height, graphicid, estimated_time, description,escape_room_id)
    @name = name
    @posx = posx
    @posy = posy
    @width = width
    @height = height
    @graphicid = graphicid
    @estimatedTime = estimated_time
    @description = description
    @roomID = escape_room_id
  end

end
