class CreatePuzzleResponse

  attr_accessor id, :time, :description

  def initialize(id, time, description)
    @id = id
    @time = time
    @description = description
  end

end
