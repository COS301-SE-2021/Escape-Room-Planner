require 'test_helper'

class ClueTest < ActiveSupport::TestCase
  def test_CreateClue
    num_clues_before = Clue.count

    escape_room = EscapeRoom.new
    escape_room.save
    er_id = escape_room.id
    req = CreatePuzzleRequest.new 'test', 0, 0, 0, 0,
                                  'graphic', 'clue', room_id

    rs = RoomServices.new
    rs.createPuzzle(req)

    assert_not_equal(Clue.count, num_clues_before)
  end

  def test_NullClue
    req = nil
    rs = RoomServices.new
    response = rs.createClue(req)
    assert_equal(false, response.success)
  end

end