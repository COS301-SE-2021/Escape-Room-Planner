require 'test_helper'
require 'concurrent'

class RoomControllerTest < ActionDispatch::IntegrationTest

    #Get Rooms
  test 'can get index' do
    get api_v1_room_index_path
    assert_response :success
  end

    #Get Room
  test 'can get certain index' do
    get "#{api_v1_room_index_path}/1"
    assert_response :success
  end

    #Get Room Fails
  test 'can get unmade index' do
    get "#{api_v1_room_index_path}/100"
    assert_response :not_found
  end

    #Create Room
  test 'can create room' do
    post api_v1_room_index_path
    assert_response :success
  end

end