# frozen_string_literal: true

require 'test_helper'
require './app/Services/PublicRoomsSubsystem/public_rooms_service'
require './app/Services/PublicRoomsSubsystem/Response/get_public_rooms_response'

# unit test all services for public rooms
class PublicRoomTest < ActiveSupport::TestCase
  # test if all public rooms returned
  test 'can get all public rooms' do
    serv = PublicRoomServices.new
    resp = serv.public_rooms
    assert_equal('testUser', resp.data[0][:username])
  end
end
