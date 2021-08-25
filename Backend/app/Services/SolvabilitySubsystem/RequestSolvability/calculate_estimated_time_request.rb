class CalculateEstimatedTimeRequest
  attr_accessor :startVert , :endVert

  def initialize(startVert, endVert)
    @startVert = startVert
    @endVert = endVert
  end

end
