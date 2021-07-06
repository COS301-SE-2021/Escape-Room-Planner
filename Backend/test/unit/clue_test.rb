# frozen_string_literal: true

require 'test_helper'

class ClueTest < ActiveSupport::TestCase
  def test_create_clue
    num_clues_before = Clue.count
    room_id = 1
    req = CreateClueRequest.new 'test', 0, 0, 0.1, 0.1,
                                'graphic', 'clue', room_id
    rs = RoomServices.new
    rs.create_clue(req)

    assert_not_equal(Clue.count, num_clues_before)
  end

  def test_null_clue
    req = nil
    rs = RoomServices.new
    response = rs.create_clue(req)
    assert_equal(false, response.success)
  end
end
