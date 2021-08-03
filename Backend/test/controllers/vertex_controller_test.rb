require 'test_helper'
class VertexControllerTest < ActionDispatch::IntegrationTest
  test 'can get index' do
    get api_v1_vertex_index_path
    assert_response :success
  end

  test 'can create Puzzle' do
    post api_v1_vertex_index_path, params: { type: 'Puzzle',
                                             name: 'Puzzle1',
                                             posx: '2',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             estimated_time: '10:12',
                                             description: 'word',
                                             roomid: '1' }

    assert_response :success
  end

  test 'cant create incorrect puzzle' do
    post api_v1_vertex_index_path, params: { type: 'Puzzle',
                                             posx: '2',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             estimated_time: '10:12',
                                             description: 'word',
                                             roomid: '1' }
    assert_response :bad_request
  end

  test 'can create correct key' do
    post api_v1_vertex_index_path, params: { type: 'Key',
                                             name: 'key1',
                                             posx: '2',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             roomid: '1' }
    assert_response :success
  end

  test 'cant create correct key' do
    post api_v1_vertex_index_path, params: { type: 'Key',
                                             name: 'Key1',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             roomid: '1' }
    assert_response :bad_request
  end

  test 'can create Container' do
    post api_v1_vertex_index_path, params: { type: 'Container',
                                             name: 'Container1',
                                             posx: '2',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             roomid: '1' }
    assert_response :success
  end

  test 'cant create Container' do
    post api_v1_vertex_index_path, params: { type: 'Container',
                                             posx: '2',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             roomid: '1' }
    assert_response :bad_request
  end

  test 'can create Clue' do
    post api_v1_vertex_index_path, params: { type: 'Clue',
                                             name: 'Clue1',
                                             clue: 'move',
                                             posx: '2',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             roomid: '1' }
    assert_response :success
  end

  test 'cant create Clue' do
    post api_v1_vertex_index_path, params: { type: 'Clue',
                                             name: 'Clue1',
                                             posx: '2',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             roomid: '1' }
    assert_response :bad_request
  end

  test 'can delete vertex' do
    delete "#{api_v1_vertex_index_path}/1"
    assert_response :ok
  end

  test 'cant delete vertex' do
    delete "#{api_v1_vertex_index_path}/500"
    assert_response :ok
  end

  # tests if vertex gets updated and correct response is received (good case)
  test 'can update vertex transformation' do
    us = UserServices.new
    req_L = LoginRequest.new('testUser', 'testPass')
    res_L = us.login(req_L)
    put "#{api_v1_vertex_index_path}/1",
        headers: { "Authorization": '"Bearer '+res_L.token+'"' }, params: {
          operation: 'transformation',
          id: 1, # id of one of the fixture vertices
          pos_x: 100, # new pos_x and pos_y
          pos_y: 100,
          width: 15, # new width and height
          height: 10
        }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Vertex updates', response['message']
  end

  # tests if vertex gets updated and correct response is received (good case)
  test 'can handle update on vertex id tha doesn\'t exist' do
    put "#{api_v1_vertex_index_path}/1", params: {
      operation: 'transformation',
      id: 5, # id of one of the fixture vertices
      pos_x: 100, # new pos_x and pos_y
      pos_y: 100,
      width: 15, # new width and height
      height: 10
    }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Vertex updates', response['message']
  end

  test 'can handle update on vertex height that is negative' do
    put "#{api_v1_vertex_index_path}/1", params: {
      operation: 'transformation',
      id: 5, # id of one of the fixture vertices
      pos_x: 100, # new pos_x and pos_y
      pos_y: 100,
      width: 15, # new width and height
      height: -10
    }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Vertex might not exist', response['message']
  end

  test 'can update vertex connections' do
    put "#{api_v1_vertex_index_path}/1", params: {
      operation: 'connection',
      from_vertex_id: 1,
      to_vertex_id: 2
    }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Vertex connection updates', response['message']
  end

  test 'can handle null id for vertex when updating connection' do
    put "#{api_v1_vertex_index_path}/1", params: {
      operation: 'connection',
      from_vertex_id: nil,
      to_vertex_id: 2
    }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :bad_request
    assert_equal 'Ensure correct parameters are given', response['message']
  end

  test 'can handle connection on wrong vertex ids' do
    put "#{api_v1_vertex_index_path}/1", params: {
      operation: 'connection',
      from_vertex_id: 5,
      to_vertex_id: 10
    }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Could not connect vertex', response['message']
  end
end
