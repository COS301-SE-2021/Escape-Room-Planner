# frozen_string_literal: true

# Request to update a vertices attribute service
class UpdateAttributeRequest
  attr_accessor :id, :name, :time_min, :time_sec, :clue, :description

  def initialize(id, name, time_min, time_sec, clue, description)
    @id = id
    @name = name
    @time_min = time_min
    @time_sec = time_sec
    @clue = clue
    @description = description
  end
end
