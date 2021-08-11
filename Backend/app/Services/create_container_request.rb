# frozen_string_literal: true

class CreateContainerRequest
  attr_accessor :name, :pos_x, :pos_y, :width, :height, :graphic_id, :room_id

  def initialize(pos_x, pos_y, width, height, graphic_id, room_id, name)
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
    @graphic_id = graphic_id
    @room_id = room_id
    @name = name
  end
end
