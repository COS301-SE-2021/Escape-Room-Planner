# frozen_string_literal: true

# Response for add graphic service
class DeleteGraphicResponse
  attr_accessor :success, :message

  def initialize(success, message)
    @success = success
    @message = message
  end
end
