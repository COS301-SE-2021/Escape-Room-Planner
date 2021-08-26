class GeneticAlgorithmResponse
  attr_accessor :success, :reason

  def initialize(success, reason = 'No reason given')
    @success = success
    @reason = reason
  end


end

