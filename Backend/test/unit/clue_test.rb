# frozen_string_literal: true

require 'test_helper'

class ClueTest < ActiveSupport::TestCase
  test 'can create a valid clue' do
    num_clues_before = Clue.count
    room_id = 1
    req = CreateClueRequest.new 'test', 0, 0, 0.1, 0.1,
                                'graphic', 'clue', room_id
    rs.create_clue(req)
    puts rs.
    assert_not_equal(Clue.count, num_clues_before)
  end

  test 'can handle null clue request' do
    req = nil
    rs = RoomServices.new
    response = rs.create_clue(req)
    assert_equal(false, response.success)
  end
end
