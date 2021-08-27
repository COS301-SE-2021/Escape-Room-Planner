# frozen_string_literal: true

require 'test_helper'

class RoomImageControllerTest < ActionDispatch::IntegrationTest
  test 'can get an image for a created escape room' do
    authed_get_call("#{api_v1_room_image_index_path}/1")

    response = JSON.parse(@response.body)

    assert_response :ok # correct status code
    assert_equal response['message'], 'Returned the room images' # correct message
    assert_equal response['data'][0]['room_image']['pos_x'], 10 # returns correct data
  end

  test 'can get handle request if no image exists' do
    authed_get_call("#{api_v1_room_image_index_path}/-1")

    response = JSON.parse(@response.body)

    assert_response :bad_request # correct status code
    assert_not_nil response['error'] # should give error
  end

  test '#create can create the vertex image' do
    authed_post_call(api_v1_room_image_index_path, {
                       pos_x: 20,
                       pos_y: 20,
                       width: 1,
                       height: 1,
                       blob_id: 1,
                       escape_room_id: 1
                     })

    response = JSON.parse(@response.body)

    assert_response :ok
    assert_equal response['message'], 'Room image created'
    assert_not_nil RoomImage.find(2)
  end

  test '#create can handle lack of params' do
    authed_post_call(api_v1_room_image_index_path, {
                       pos_y: 20,
                       width: 1,
                       height: 1,
                       blob_id: 1,
                       escape_room_id: 1
                     })

    response = JSON.parse(@response.body)

    assert_response :bad_request
    assert_equal response['message'], 'Not all parameters were included'
    assert_equal RoomImage.where(id: 2).length, 0
  end

  # TODO: finish all the tests
end
