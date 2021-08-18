class CalculateSolvableResponse
  attr_accessor :solvable, :reason

  def initialize(solvable, reason='No reason given')
    @solvable = solvable
    @reason = reason
  end


end
