require 'test_helper'

class RoomControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "/api/v1/room(.:format)"
    assert_response :success
  end
end