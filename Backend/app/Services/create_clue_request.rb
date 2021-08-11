# frozen_string_literal: true

class CreateClueRequest
  attr_accessor :name, :pos_x, :pos_y, :width, :height, :graphic_id, :clue, :room_id

  def initialize(name, pos_x, pos_y, width, height, graphic_id, clue, room_id)
    @name = name
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
    @graphic_id = graphic_id
    @clue = clue
    @room_id = room_id
  end
end
