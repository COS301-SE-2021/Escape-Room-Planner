# frozen_string_literal: true

class GetPublicRoomsResponse
  attr_accessor :success, :message, :data

  def initialize(success, message, data)
    @success = success
    @message = message
    @data = data
  end
end
