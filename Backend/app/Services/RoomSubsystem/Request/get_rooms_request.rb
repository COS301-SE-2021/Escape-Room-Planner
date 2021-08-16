# frozen_string_literal: true

# Request for get vertices service
class GetRoomsRequest
  attr_accessor :token

  def initialize(token)
    @token = token
  end
end
