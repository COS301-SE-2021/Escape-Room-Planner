require 'test_helper'

class EscapeRoomTest < ActiveSupport::TestCase
  test 'can create valid escape room' do
    room = EscapeRoom.new(name: 'some name')
    assert room.save
  end

  test 'doesnt save a room without name' do
    room = EscapeRoom.new(name: nil) # creates a nameless room
    assert_not room.save
  end
end
