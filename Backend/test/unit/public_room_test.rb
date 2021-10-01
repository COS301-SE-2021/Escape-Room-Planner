# frozen_string_literal: true

require 'test_helper'
require './app/Services/PublicRoomsSubsystem/public_rooms_service'
require './app/Services/PublicRoomsSubsystem/Response/get_public_rooms_response'
require './app/Services/PublicRoomsSubsystem/Request/add_public_room_request'
require './app/Services/PublicRoomsSubsystem/Response/add_public_room_response'

# unit test all services for public rooms
class PublicRoomTest < ActiveSupport::TestCase
  # test if all public rooms returned
  test 'can get all public rooms' do
    serv = PublicRoomServices.new
    resp = serv.public_rooms
    assert_equal('testUser', resp.data[0][:username])
  end

  # test if user can add public room
  test 'can add public room' do
    req = AddPublicRoomRequest.new(login_for_test, 7)
    serv = PublicRoomServices.new
    resp = serv.add_public_room(req)
    assert_equal('Room set to public', resp.message)
  end
end
