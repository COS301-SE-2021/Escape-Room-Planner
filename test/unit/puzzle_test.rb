require 'test_helper'
require './app/Services/puzzle_services'
require './app/Services/create_puzzle_request'
require './app/Services/create_puzzle_response'



class PuzzleTest < ActiveSupport::TestCase

  def test_createPuzzle

    # beforetest=EscapeRoom.count
    req = CreatePuzzleRequest.new("30", 30, "Recreate the image")
    rs = PuzzleServices.new
    rs.create(req)

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