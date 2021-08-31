class ReturnUnnecessaryRequest
  attr_accessor :start_vert , :end_vert, :room_id

  def initialize(start_vert, end_vert, room_id)
    @start_vert = start_vert
    @end_vert = end_vert
    @room_id = room_id
  end

end

