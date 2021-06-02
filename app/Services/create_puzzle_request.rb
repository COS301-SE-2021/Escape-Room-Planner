class CreatePuzzleRequest

  attr_accessor :time, :description

  def initialize(time, description)
    @time = time
    @description = description
  end

end
