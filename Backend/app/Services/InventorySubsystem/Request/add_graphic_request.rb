# frozen_string_literal: true

# Request for add graphic service
class AddGraphicRequest
  attr_accessor :token, :image

  def initialize(token, image)
    @token = token
    @image = image
  end
end
