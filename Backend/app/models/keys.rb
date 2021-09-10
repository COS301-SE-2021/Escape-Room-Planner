# frozen_string_literal: true

# validates :z_index default of 5
# Keys model that inherits from Vertex model
class Keys < Vertex
  attribute :z_index, :float, default: 5
end
