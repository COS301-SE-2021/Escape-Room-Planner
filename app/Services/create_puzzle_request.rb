class CreatePuzzleRequest

  attr_accessor :name, :posx, :posy, :width, :height, :graphicid, :nextV, :estimatedTime, :description, :roomID
  
  def initialize
    @name = ''
    @posx = ''
    @posy = ''
    @width = ''
    @height = ''
    @graphicid = ''
    @nextV = ''
    @estimatedTime = Time.now
    @description = ''
    @roomID = 0
  end

end
