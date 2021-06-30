require 'test_helper'

class ClueTest < ActiveSupport::TestCase
  def test_CreateClue
    num_clues_before = Clue.count

    room = EscapeRoom.new(name:"test name")
    room.save
    room_id = room.id
    req = CreateClueRequest.new 'test', 0, 0, 0.1, 0.1,
                                'graphic', 'clue', room_id

    rs = RoomServices.new
    rs.createClue(req)

    assert_not_equal(Clue.count, num_clues_before)
  end

  def test_NullClue
    req = nil
    rs = RoomServices.new
    response = rs.createClue(req)
    assert_equal(false, response.success)
  end

end