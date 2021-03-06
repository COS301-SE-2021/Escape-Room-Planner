require 'test_helper'
require 'concurrent'

class RoomControllerTest < ActionDispatch::IntegrationTest
  BEARER = '"Bearer '.freeze
  # Show Rooms
  test 'can get all rooms' do
    authed_get_call(api_v1_room_index_path)
    assert_response :success
  end

  # Get Room
  test 'can get certain index' do
    authed_get_call("#{api_v1_room_index_path}/1")
    assert_response :success
  end

  # Get Room Fails
  test 'can get unmade index' do
    authed_get_call("#{api_v1_room_index_path}/100")
    assert_response :not_found
  end

  # Create Room
  test 'can create room' do
    authed_post_call(api_v1_room_index_path, nil)
    assert_response :success
  end

  test 'can delete valid room' do
    authed_delete_call("#{api_v1_room_index_path}/1", nil)
    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Deleted Room', response['message']
  end

  test 'can handle delete escape room when room not exist' do
    authed_delete_call("#{api_v1_room_index_path}/-1", nil)
    response = JSON.parse(@response.body)
    assert_response :bad_request
    assert_equal 'Room does not exist', response['message']
  end

  test 'set start room' do
    response = authed_put_request("#{api_v1_room_index_path}/1", {
                                    operation: 'setStart',
                                    id: '1',
                                    startVertex: '1'
                                  })

    assert_response :ok
  end
end
