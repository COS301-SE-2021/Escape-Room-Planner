# frozen_string_literal: true

# Response for connect vertices service
class ConnectVerticesResponse
  attr_accessor :success, :message

  def initialize(success, message)
    @success = success
    @message = message
  end
end
