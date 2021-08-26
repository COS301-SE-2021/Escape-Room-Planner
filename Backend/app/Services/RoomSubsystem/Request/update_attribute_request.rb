# frozen_string_literal: true

# Request to update a vertices attribute service
class UpdateAttributeRequest
  attr_accessor :id, :name, :time, :clue, :description

  def initialize(id, name, time, clue, description)
    @id = id
    @name = name
    @time = time
    @clue = clue
    @description = description
  end
end
