require 'test_helper'
require 'concurrent'

class RoomControllerTest < ActionDispatch::IntegrationTest
  # Get Rooms
  test 'can get all rooms' do
    get api_v1_room_index_path

    puts @response.body

    assert_response :success
  end

  # Get Room
  test 'can get certain index' do
    get "#{api_v1_room_index_path}/1"
    assert_response :success
  end

  # Get Room Fails
  test 'can get unmade index' do
    get "#{api_v1_room_index_path}/100"
    assert_response :not_found
  end

  # Create Room
  test 'can create room' do
    post api_v1_room_index_path
    assert_response :success
  end

  test 'can delete valid room' do
    delete "#{api_v1_room_index_path}/1"

    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Deleted Room', response['message']
  end

  test 'can handle delete escape room when room not exist' do
    delete "#{api_v1_room_index_path}/-1"

    response = JSON.parse(@response.body)
    assert_response :bad_request
    assert_equal 'Room does not exist', response['message']
  end
end
