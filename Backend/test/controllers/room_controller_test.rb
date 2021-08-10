require 'test_helper'
require 'concurrent'

class RoomControllerTest < ActionDispatch::IntegrationTest
  # Show Rooms
  test 'can get all rooms' do
    us = UserServices.new
    req_l = LoginRequest.new('testUser', 'testPass')
    res_l = us.login(req_l)
    get api_v1_room_index_path,
        headers: { "Authorization": '"Bearer ' + res_l.token + '"' }

    puts @response.body

    assert_response :success
  end

  # Get Room
  test 'can get certain index' do
    us = UserServices.new
    req_l = LoginRequest.new('testUser', 'testPass')
    res_l = us.login(req_l)
    get "#{api_v1_room_index_path}/1",
        headers: { "Authorization": '"Bearer ' + res_l.token + '"' }
    assert_response :success
  end

  # Get Room Fails
  test 'can get unmade index' do
    us = UserServices.new
    req_l = LoginRequest.new('testUser', 'testPass')
    res_l = us.login(req_l)
    get "#{api_v1_room_index_path}/100",
        headers: { "Authorization": '"Bearer ' + res_l.token + '"' }
    assert_response :not_found
  end

  # Create Room
  test 'can create room' do
    us = UserServices.new
    req_l = LoginRequest.new('testUser', 'testPass')
    res_l = us.login(req_l)
    post api_v1_room_index_path,
         headers: { "Authorization": '"Bearer ' + res_l.token + '"' }
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
