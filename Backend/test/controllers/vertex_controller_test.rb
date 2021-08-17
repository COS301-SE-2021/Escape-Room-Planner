# frozen_string_literal: true

require 'test_helper'
class VertexControllerTest < ActionDispatch::IntegrationTest
  test 'can get index' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # get api_v1_vertex_index_path,
    #     headers: { "Authorization": "\"Bearer #{res_l.token}\"" }

    authed_get_call(api_v1_vertex_index_path)

    assert_response :success
  end

  test 'can get vertices based on escape room id' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # get "#{api_v1_vertex_index_path}/1",
    #     headers: { "Authorization": "\"Bearer #{res_l.token}\"" }

    authed_get_call("#{api_v1_vertex_index_path}/1")

    assert_response :ok
  end

  test 'can handle a show when incorrect escape room id is provided' do
    authed_get_call("#{api_v1_vertex_index_path}/-1")
    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal(response['message'], 'Can not locate user')
  end

  test 'can create Puzzle' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # post api_v1_vertex_index_path,
    #      headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #      params: { operation: 'create',
    #                type: 'Puzzle',
    #                name: 'Puzzle1',
    #                posx: '2',
    #                posy: '3',
    #                width: '4',
    #                height: '5',
    #                graphicid: '123',
    #                estimated_time: '10:12',
    #                description: 'word',
    #                roomid: '1' }

    authed_post_call(api_v1_vertex_index_path, { operation: 'create',
                                                 type: 'Puzzle',
                                                 name: 'Puzzle1',
                                                 posx: '2',
                                                 posy: '3',
                                                 width: '4',
                                                 height: '5',
                                                 graphicid: '123',
                                                 estimated_time: '10:12',
                                                 description: 'word',
                                                 roomid: '1' })

    assert_response :success
  end

  test 'cant create incorrect puzzle' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # post api_v1_vertex_index_path,
    #      headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #      params: { type: 'Puzzle',
    #                posx: '2',
    #                posy: '3',
    #                width: '4',
    #                height: '5',
    #                graphicid: '123',
    #                estimated_time: '10:12',
    #                description: 'word',
    #                roomid: '1' }

    authed_post_call(api_v1_vertex_index_path, { type: 'Puzzle',
                                                 posx: '2',
                                                 posy: '3',
                                                 width: '4',
                                                 height: '5',
                                                 graphicid: '123',
                                                 estimated_time: '10:12',
                                                 description: 'word',
                                                 roomid: '1' })

    assert_response :bad_request
  end

  test 'can create correct key' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # post api_v1_vertex_index_path,
    #      headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #      params: { type: 'Key',
    #                name: 'key1',
    #                posx: '2',
    #                posy: '3',
    #                width: '4',
    #                height: '5',
    #                graphicid: '123',
    #                roomid: '1' }

    authed_post_call(api_v1_vertex_index_path, { type: 'Key',
                                                 name: 'key1',
                                                 posx: '2',
                                                 posy: '3',
                                                 width: '4',
                                                 height: '5',
                                                 graphicid: '123',
                                                 roomid: '1' })

    assert_response :success
  end

  test 'cant create correct key' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # post api_v1_vertex_index_path,
    #      headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #      params: { type: 'Key',
    #                name: 'Key1',
    #                posy: '3',
    #                width: '4',
    #                height: '5',
    #                graphicid: '123',
    #                roomid: '1' }

    authed_post_call(api_v1_vertex_index_path, { type: 'Key',
                                                 name: 'Key1',
                                                 posy: '3',
                                                 width: '4',
                                                 height: '5',
                                                 graphicid: '123',
                                                 roomid: '1' })

    assert_response :bad_request
  end

  test 'can create Container' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # post api_v1_vertex_index_path,
    #      headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #      params: { type: 'Container',
    #                name: 'Container1',
    #                posx: '2',
    #                posy: '3',
    #                width: '4',
    #                height: '5',
    #                graphicid: '123',
    #                roomid: '1' }

    authed_post_call(api_v1_vertex_index_path, { type: 'Container',
                                                 name: 'Container1',
                                                 posx: '2',
                                                 posy: '3',
                                                 width: '4',
                                                 height: '5',
                                                 graphicid: '123',
                                                 roomid: '1' })

    assert_response :success
  end

  test 'cant create Container' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # post api_v1_vertex_index_path,
    #      headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #      params: { type: 'Container',
    #                posx: '2',
    #                posy: '3',
    #                width: '4',
    #                height: '5',
    #                graphicid: '123',
    #                roomid: '1' }

    authed_post_call(api_v1_vertex_index_path, { type: 'Container',
                                                 posx: '2',
                                                 posy: '3',
                                                 width: '4',
                                                 height: '5',
                                                 graphicid: '123',
                                                 roomid: '1' })

    assert_response :bad_request
  end

  test 'can create Clue' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # post api_v1_vertex_index_path,
    #      headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #      params: { type: 'Clue',
    #                name: 'Clue1',
    #                clue: 'move',
    #                posx: '2',
    #                posy: '3',
    #                width: '4',
    #                height: '5',
    #                graphicid: '123',
    #                roomid: '1' }

    authed_post_call(api_v1_vertex_index_path, { type: 'Clue',
                                                 name: 'Clue1',
                                                 clue: 'move',
                                                 posx: '2',
                                                 posy: '3',
                                                 width: '4',
                                                 height: '5',
                                                 graphicid: '123',
                                                 roomid: '1' })

    assert_response :success
  end

  test 'cant create Clue' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # post api_v1_vertex_index_path,
    #      headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #      params: { type: 'Clue',
    #                name: 'Clue1',
    #                posx: '2',
    #                posy: '3',
    #                width: '4',
    #                height: '5',
    #                graphicid: '123',
    #                roomid: '1' }

    authed_post_call(api_v1_vertex_index_path, { type: 'Clue',
                                                 name: 'Clue1',
                                                 posx: '2',
                                                 posy: '3',
                                                 width: '4',
                                                 height: '5',
                                                 graphicid: '123',
                                                 roomid: '1' })

    assert_response :bad_request
  end

  # test when incorrect operation call when delete request called
  test 'incorrect operation call on delete request' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # delete "#{api_v1_vertex_index_path}/1",
    #        headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #        params: { id: '1' }
    #
    # response = JSON.parse(@response.body)
    response = authed_delete_call("#{api_v1_vertex_index_path}/1", { id: '1' })
    assert_response :bad_request
    assert_equal 'Operation does not exist', response['message']
  end

  test 'can delete vertex' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # delete "#{api_v1_vertex_index_path}/1",
    #        headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #        params: { operation: 'remove_vertex',
    #                  id: '1' }
    # response = JSON.parse(@response.body)

    response = authed_delete_call("#{api_v1_vertex_index_path}/1", { operation: 'remove_vertex',
                                                                     id: '1' })

    assert_response :ok
    assert_equal 'Vertex:', response['message']
  end

  test 'cant delete vertex' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # delete "#{api_v1_vertex_index_path}/500",
    #        headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #        params: { operation: 'remove_vertex',
    #                  id: '500' }
    # response = JSON.parse(@response.body)

    response = authed_delete_call("#{api_v1_vertex_index_path}/500", { operation: 'remove_vertex',
                                                                       id: '500' })

    assert_response :ok
    assert_equal 'Unable to remove vertex', response['message']
  end

  # test if vertex removes connection and correct response is received (good case)
  test 'can remove connection' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # delete "#{api_v1_vertex_index_path}/1",
    #        headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #        params: { operation: 'disconnect_vertex',
    #                  from_vertex_id: '1',
    #                  to_vertex_id: '2' }
    # response = JSON.parse(@response.body)

    response = authed_delete_call("#{api_v1_vertex_index_path}/1", { operation: 'disconnect_vertex',
                                                                     from_vertex_id: '1',
                                                                     to_vertex_id: '2' })

    assert_response :ok
    assert_equal 'Link has been removed', response['message']
  end

  # test if vertex has no connection and tries to remove with correct response received (bad case)
  test 'can handle vertex with no connections' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # delete "#{api_v1_vertex_index_path}/1",
    #        headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #        params: { operation: 'disconnect_vertex',
    #                  from_vertex_id: '1',
    #                  to_vertex_id: '5' }
    # response = JSON.parse(@response.body)

    response = authed_delete_call("#{api_v1_vertex_index_path}/1", { operation: 'disconnect_vertex',
                                                                     from_vertex_id: '1',
                                                                     to_vertex_id: '5' })

    assert_response :ok
    assert_equal 'There is no link between vertices', response['message']
  end

  # test if vertex does not exist when removing connection with correct response received (bad case)
  test 'can handle vertex that doesnt exist' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # delete "#{api_v1_vertex_index_path}/1",
    #        headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #        params: { operation: 'disconnect_vertex',
    #                  from_vertex_id: '100',
    #                  to_vertex_id: '5' }
    # response = JSON.parse(@response.body)

    response = authed_delete_call("#{api_v1_vertex_index_path}/1", { operation: 'disconnect_vertex',
                                                                     from_vertex_id: '100',
                                                                     to_vertex_id: '5' })

    assert_response :ok
    assert_equal 'From vertex could not be found', response['message']
  end

  # test if nil passed for vertex while removing connection with correct response received (bad case)
  test 'can handle nil vertex passed disconnect vertex' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # delete "#{api_v1_vertex_index_path}/1",
    #        headers: { "Authorization": "\"Bearer #{res_l.token}\"" },
    #        params: { operation: 'disconnect_vertex',
    #                  to_vertex_id: '5' }
    # response = JSON.parse(@response.body)

    response = authed_delete_call("#{api_v1_vertex_index_path}/1", { operation: 'disconnect_vertex',
                                                                     to_vertex_id: '5' })

    assert_response :bad_request
    assert_equal 'Pass in correct parameters', response['message']
  end

  # tests if vertex gets updated and correct response is received (good case)
  test 'can update vertex transformation' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # put "#{api_v1_vertex_index_path}/1",
    #     headers: { "Authorization": "\"Bearer #{res_l.token}\"" }, params: {
    #       operation: 'transformation',
    #       id: 1, # id of one of the fixture vertices
    #       pos_x: 100, # new pos_x and pos_y
    #       pos_y: 100,
    #       width: 15, # new width and height
    #       height: 10
    #     }, as: :as_json
    #
    # response = JSON.parse(@response.body)

    response = authed_put_request("#{api_v1_vertex_index_path}/1", {
                                    operation: 'transformation',
                                    id: 1, # id of one of the fixture vertices
                                    pos_x: 100, # new pos_x and pos_y
                                    pos_y: 100,
                                    width: 15, # new width and height
                                    height: 10
                                  })

    assert_response :ok
    assert_equal 'Vertex updates', response['message']
  end

  # tests if vertex gets updated and correct response is received (good case)
  test 'can handle update on vertex id tha doesn\'t exist' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # put "#{api_v1_vertex_index_path}/1",
    #     headers: { "Authorization": "\"Bearer #{res_l.token}\"" }, params: {
    #       operation: 'transformation',
    #       id: 5, # id of one of the fixture vertices
    #       pos_x: 100, # new pos_x and pos_y
    #       pos_y: 100,
    #       width: 15, # new width and height
    #       height: 10
    #     }, as: :as_json
    #
    # response = JSON.parse(@response.body)

    response = authed_put_request("#{api_v1_vertex_index_path}/1", {
                                    operation: 'transformation',
                                    id: 5, # id of one of the fixture vertices
                                    pos_x: 100, # new pos_x and pos_y
                                    pos_y: 100,
                                    width: 15, # new width and height
                                    height: 10
                                  })

    assert_response :ok
    assert_equal 'Vertex updates', response['message']
  end

  test 'can handle update on vertex height that is negative' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # put "#{api_v1_vertex_index_path}/1",
    #     headers: { "Authorization": "\"Bearer #{res_l.token}\"" }, params: {
    #       operation: 'transformation',
    #       id: 5, # id of one of the fixture vertices
    #       pos_x: 100, # new pos_x and pos_y
    #       pos_y: 100,
    #       width: 15, # new width and height
    #       height: -10
    #     }, as: :as_json
    #
    # response = JSON.parse(@response.body)

    response = authed_put_request("#{api_v1_vertex_index_path}/1", {
                                    operation: 'transformation',
                                    id: 5, # id of one of the fixture vertices
                                    pos_x: 100, # new pos_x and pos_y
                                    pos_y: 100,
                                    width: 15, # new width and height
                                    height: -10
                                  })

    assert_response :ok
    assert_equal 'Vertex might not exist', response['message']
  end

  test 'can update vertex connections' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # put "#{api_v1_vertex_index_path}/1",
    #     headers: { "Authorization": "\"Bearer #{res_l.token}\"" }, params: {
    #       operation: 'connection',
    #       from_vertex_id: 1,
    #       to_vertex_id: 2
    #     }, as: :as_json
    #
    # response = JSON.parse(@response.body)

    response = authed_put_request("#{api_v1_vertex_index_path}/1", {
                                    operation: 'connection',
                                    from_vertex_id: 1,
                                    to_vertex_id: 2
                                  })

    assert_response :ok
    assert_equal 'Vertex connection updates', response['message']
  end

  test 'can handle null id for vertex when updating connection' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # put "#{api_v1_vertex_index_path}/1",
    #     headers: { "Authorization": "\"Bearer #{res_l.token}\"" }, params: {
    #       operation: 'connection',
    #       from_vertex_id: nil,
    #       to_vertex_id: 2
    #     }, as: :as_json
    #
    # response = JSON.parse(@response.body)

    response = authed_put_request("#{api_v1_vertex_index_path}/1", {
                                    operation: 'connection',
                                    from_vertex_id: nil,
                                    to_vertex_id: 2
                                  })

    assert_response :bad_request
    assert_equal 'Ensure correct parameters are given', response['message']
  end

  test 'can handle connection on wrong vertex ids' do
    # us = UserServices.new
    # req_l = LoginRequest.new('testUser', 'testPass')
    # res_l = us.login(req_l)
    # put "#{api_v1_vertex_index_path}/1",
    #     headers: { "Authorization": "\"Bearer #{res_l.token}\"" }, params: {
    #       operation: 'connection',
    #       from_vertex_id: 5,
    #       to_vertex_id: 10
    #     }, as: :as_json
    #
    # response = JSON.parse(@response.body)

    response = authed_put_request("#{api_v1_vertex_index_path}/1", {
                                    operation: 'connection',
                                    from_vertex_id: 5,
                                    to_vertex_id: 10
                                  })

    assert_response :ok
    assert_equal 'Could not connect vertex', response['message']
  end

end
