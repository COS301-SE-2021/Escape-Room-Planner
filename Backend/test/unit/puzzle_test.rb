require 'test_helper'

class PuzzleTest < ActiveSupport::TestCase
  test 'test create puzzle' do
    before_test = Puzzle.count
    room_id = 1
    req = CreatePuzzleRequest.new 'test', 0, 0, 0.2, 0.2, 'graphic',
                                  Time.now, 'test description', room_id, 1
    rs = RoomServices.new
    rs.create_puzzle(req)

    # assertion
    assert_not_equal(Puzzle.count, before_test)
  end

  test 'test check create puzzle null request' do
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError) { rs.create_puzzle(req) }
    assert_equal('CreatePuzzleRequest null', exception.message)
  end
end
