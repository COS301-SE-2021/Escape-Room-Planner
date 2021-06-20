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
                                             roomid: '1'

    }

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
                                             roomid: '1'

    }
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
                                             roomid: '1'

    }
    assert_response :success

  end

  test 'cant create correct key' do
    post api_v1_vertex_index_path, params: { type: 'Key',
                                             name: 'Key1',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             roomid: '1'

    }
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
                                             roomid: '1'

    }
    assert_response :success
  end

  test 'cant create Container' do
    post api_v1_vertex_index_path, params: { type: 'Container',
                                             posx: '2',
                                             posy: '3',
                                             width: '4',
                                             height: '5',
                                             graphicid: '123',
                                             roomid: '1'

    }
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
                                             roomid: '1'

    }
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
                                             roomid: '1'

    }
    assert_response :bad_request
  end

  test 'can delete vertex' do
    delete "#{api_v1_vertex_index_path}/1"
    assert_response :ok
  end

  test 'cant delete vertex' do
    delete "#{api_v1_vertex_index_path}/500"
    assert_response :bad_request
  end

end
