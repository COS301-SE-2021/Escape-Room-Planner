# frozen_string_literal: true

# Request for create Escape Room service
class CreateEscapeRoomRequest
  attr_accessor :name, :token

  # later will need a user id to create
  def initialize(name, token)
    @name = name
    @token = token
  end
end
