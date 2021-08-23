# frozen_string_literal: true

# validates :estimated_time
# validates :description
# validates :z_index default of 5
# Puzzle model that inherits from Vertex model
class Puzzle < Vertex
  validates :estimatedTime, :description, presence: true # just checks presence, since can be anything for user.
  attribute :z_index, :float, default: 5
end
