# frozen_string_literal: true

# Request for add graphic service
class GetGraphicsRequest
  attr_accessor :token

  def initialize(token)
    @token = token
  end
end
