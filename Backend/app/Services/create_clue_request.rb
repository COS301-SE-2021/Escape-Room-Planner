# frozen_string_literal: true

# request for Create Clue Service
class CreateClueRequest
  attr_accessor :name, :pos_x, :pos_y, :width, :height, :graphic_id, :clue, :room_id, :blob_id

  def initialize(name, pos_x, pos_y, width, height, graphic_id, clue, room_id, blob_id)
    @name = name
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
    @graphic_id = graphic_id
    @clue = clue
    @room_id = room_id
    @blob_id = blob_id
  end
end
