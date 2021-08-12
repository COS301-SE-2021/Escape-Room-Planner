# frozen_string_literal: true

# Request for add graphic service
class GetGraphicsResponse
  attr_accessor :success, :message, :image

  def initialize(success, message, image)
    @success = success
    @message = message
    @image = image
  end
end
