# frozen_string_literal: true

# validates :clue
# validates :z_index default of 5
# Clue model that inherits from Vertex model
class Clue < Vertex
  validates :clue, presence: true # just needs to have a clue text of some sort
  attribute :z_index, :float, default: 5
end
