# frozen_string_literal: true

class AddRatingRequest
  attr_accessor :room_id, :token, :rating

  def initialize(room_id, token, rating)
    @room_id = room_id
    @token = token
    @rating = rating
  end
end
