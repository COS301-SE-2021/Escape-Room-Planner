require 'test_helper'
require './app/Services/room_services'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'



class ErTest < ActiveSupport::TestCase

  def test_createEscapeRoom

    beforetest=EscapeRoom.count
    req = CreateEscaperoomRequest.new
    rs = RoomServices.new
    rs.createEscapeRoom(req)

    assert_not_equal(EscapeRoom.count, beforetest)
  end

  def test_checkCreateEscapeRoomSaved
    req = CreateEscaperoomRequest.new
    rs = RoomServices.new
    resp = rs.createEscapeRoom(req)

    assert_not_equal(resp.id, 0)
  end

  def test_checkCreateEscapeRoomNullRequest
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError){rs.createEscapeRoom(req)}
    assert_equal("CreateEscaperoomRequest null", exception.message)
  end

end