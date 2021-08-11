# frozen_string_literal: true

# Response for add graphic service
class AddGraphicResponse
  attr_accessor :success, :message

  def initialize(success, message)
    @success = success
    @message = message
  end
end