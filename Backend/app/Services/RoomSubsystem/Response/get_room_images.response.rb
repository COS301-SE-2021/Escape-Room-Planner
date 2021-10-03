# frozen_string_literal: true

# Response for get room images service
class GetRoomImagesResponse
  attr_accessor :success, :message, :data

  def initialize(success, message, data)
    @success = success
    @message = message
    @data = data
  end
end
