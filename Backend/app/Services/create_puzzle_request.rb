# frozen_string_literal: true

# request for create puzzle feature
class CreatePuzzleRequest
  attr_accessor :name, :pos_x, :pos_y, :width, :height, :graphic_id, :estimated_time, :description, :room_id, :blob_id

  def initialize(name, pos_x, pos_y, width, height, graphic_id, estimated_time, description, room_id, blob_id)
    @name = name
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
    @graphic_id = graphic_id
    @estimated_time = estimated_time
    @description = description
    @room_id = room_id
    @blob_id = blob_id
  end
end
