require 'test_helper'

class PuzzleTest < ActiveSupport::TestCase

  def test_createPuzzle

    beforetest = Puzzle.count
    room = EscapeRoom.new(name:'test name')
    room.save
    room_id = room.id
    req = CreatePuzzleRequest.new 'test', 0, 0, 0.2, 0.2,
                                  'graphic', Time.now, 'test description', room_id
    rs = RoomServices.new
    rs.createPuzzle(req)

    # assertion
    assert_not_equal(Puzzle.count, beforetest)
  end

  def test_checkCreatePuzzleNullRequest
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError){rs.createPuzzle(req)}
    assert_equal("CreatePuzzleRequest null", exception.message)
  end

end