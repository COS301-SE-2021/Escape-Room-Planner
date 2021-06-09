require 'test_helper'


class CreateKeyTest < ActiveSupport::TestCase

  def test_CreateKey

    num_keys_before = Keys.count

    escape_room = EscapeRoom.new
    escape_room.save
    er_id = escape_room.id

    req = CreateKeyRequest.new 'test', 0, 0, 0, 0, 'graphic', er_id

    rs = RoomServices.new
    rs.createKey(req)

    assert_not_equal(Keys.count, num_keys_before)

  end

  def test_NullKey
    req = nil
    rs = RoomServices.new
    response = rs.createKey(req)
    assert_equal(false, response.success)

  end
end