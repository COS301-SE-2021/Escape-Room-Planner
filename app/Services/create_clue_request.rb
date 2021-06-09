class CreateCLueRequest
  attr_accessor :name, :posx, :posy, :width, :height, :graphicid, :clue, :roomID

  def initialize(name, posx, posy, width, height, graphicid, clue, escape_room_id)
    @name = name
    @posx = posx
    @posy = posy
    @width = width
    @height = height
    @graphicid = graphicid
    @clue = clue
    @roomID = escape_room_id
  end

end