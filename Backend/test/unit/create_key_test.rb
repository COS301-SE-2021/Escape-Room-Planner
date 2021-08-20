require 'test_helper'

class CreateKeyTest < ActiveSupport::TestCase
  test 'test create key' do
    num_keys_before = Keys.count
    er_id = 1
    req = CreateKeyRequest.new 'test', 0, 0, 0.1, 0.1, 'graphic',
                               er_id, 1
    rs = RoomServices.new
    rs.create_key(req)

    assert_not_equal(Keys.count, num_keys_before)
  end

  test 'test null request' do
    req = nil
    rs = RoomServices.new
    response = rs.create_key(req)

    assert_equal(false, response.success)
  end
end
