# frozen_string_literal: true

# Create Container request feature
class CreateContainerRequest
  attr_accessor :name, :pos_x, :pos_y, :width, :height, :graphic_id, :room_id, :blob_id

  def initialize(pos_x, pos_y, width, height, graphic_id, room_id, name, blob_id)
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
    @graphic_id = graphic_id
    @room_id = room_id
    @name = name
    @blob_id = blob_id
  end
end
