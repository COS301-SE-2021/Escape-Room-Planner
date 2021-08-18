# frozen_string_literal: true

# Request for add graphic service
class AddGraphicRequest
  attr_accessor :token, :image, :type

  def initialize(token, image, type)
    @token = token
    @image = image
    @type = type
  end
end
