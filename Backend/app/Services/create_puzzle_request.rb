class CreatePuzzleRequest
  attr_accessor :name, :pos_x, :pos_y, :width, :height, :graphic_id, :estimated_time, :description, :room_id

  def initialize(name, pos_x, pos_y, width, height, graphic_id, estimated_time, description, room_id)
    @name = name
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
    @graphic_id = graphic_id
    @estimated_time = estimated_time
    @description = description
    @room_id = room_id
  end
end
