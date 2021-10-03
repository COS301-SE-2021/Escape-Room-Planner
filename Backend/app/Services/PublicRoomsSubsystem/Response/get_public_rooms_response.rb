# frozen_string_literal: true

# a response structure of public room get request
class GetPublicRoomsResponse
  attr_accessor :success, :message, :data

  def initialize(success, message, data)
    @success = success
    @message = message
    @data = data
  end
end
