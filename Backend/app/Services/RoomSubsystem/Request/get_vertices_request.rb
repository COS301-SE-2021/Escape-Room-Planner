# frozen_string_literal: true

# Request for get vertices service
class GetVerticesRequest
  attr_accessor :id

  def initialize(id)
    @id = id
  end
end
