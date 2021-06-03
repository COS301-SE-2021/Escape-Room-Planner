require 'test_helper'

class PuzzleTest < ActiveSupport::TestCase

  def test_createPuzzle

    beforetest = Puzzle.count
    room = EscapeRoom.new
    room.save
    roomID = room.id
    req = CreatePuzzleRequest.new
    req.roomID = roomID
    rs = RoomServices.new
    rs.createPuzzle(req)

    assert_not_equal(Puzzle.count, beforetest)

  end

  def test_checkCreatePuzzleSaved

    room = EscapeRoom.new
    room.save
    roomID = room.id
    req = CreatePuzzleRequest.new
    req.roomID = roomID
    rs = RoomServices.new
    resp = rs.createPuzzle(req)

    assert_not_equal(resp.id, 0)
  end

  def test_checkCreatePuzzleNullRequest
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError){rs.createPuzzle(req)}
    assert_equal("CreatePuzzleRequest null", exception.message)
  end

end