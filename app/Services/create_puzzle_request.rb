class CreatePuzzleRequest
  def initialize(time, pieces, description)
    @time = time
    @pieces = pieces
    @description = description
  end

  # get method
  def get_time
    @time
  end

  # get method
  def get_pieces
    @pieces
  end

  # get method
  def get_description
    @description
  end
end
