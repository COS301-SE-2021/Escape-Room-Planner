class CreatePuzzleRequest

  attr_accessor :name, :posx, :posy, :width, :height, :graphicid, :nextV, :estimatedTime, :description
  
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
  end

end
