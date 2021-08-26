class CalculateEstimatedTimeResponse
  attr_accessor :time, :status

  def initialize(time, status)
    @time = time
    @status=status
  end
end
