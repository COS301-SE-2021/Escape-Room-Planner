# frozen_string_literal: true

# request for Create Key feature
class CreateKeyRequest
  attr_accessor :name, :pos_x, :pos_y, :width, :height, :graphic_id, :description, :room_id, :blob_id

  def initialize(name, pos_x, pos_y, width, height, graphic_id, room_id, blob_id)
    @name = name
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
    @graphic_id = graphic_id
    @room_id = room_id
    @blob_id = blob_id
  end
end
