require 'test_helper'
require './app/Services/room_services'
require './app/Services/create_escapeRoom_request'
require './app/Services/create_escapeRoom_response'

class ErTest < ActiveSupport::TestCase

  # test if escape room can be made
  test 'test create escape room' do
    before_test = EscapeRoom.count
    req = CreateEscapeRoomRequest.new("test name")
    rs = RoomServices.new
    rs.create_escape_room(req)

    assert_not_equal(EscapeRoom.count, before_test)
  end

  # test if service returns an exception
  test 'test create escape room with null request' do
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError){ rs.create_escape_room(req) }
    assert_equal('CreateEscapeRoomRequest null', exception.message)
  end

  def test_remove_vertex
    before_test = Vertex.count
    req = RemoveVertexRequest.new(1)
    rs = RoomServices.new
    res = rs.remove_vertex(req)

    assert_not_equal(Vertex.count, before_test)
    assert_equal(res.success, true)
  end

  def test_remove_vertex_response_failed

    req = RemoveVertexRequest.new(6)
    rs = RoomServices.new
    res = rs.remove_vertex(req)

    assert_equal(res.success, false)
  end

  def test_remove_vertex_vertices_removed

    vertex = Vertex.find(1)
    before_test = vertex.vertices.count
    req = RemoveVertexRequest.new(1)
    rs = RoomServices.new
    rs.remove_vertex(req)

    assert_not_equal(before_test, 0)
    assert_equal(vertex.vertices.count, 0)
  end

  test 'room does reset' do
    req = ResetEscapeRoomRequest.new 1234, 1 # auth is trivial in here
    before_test = Vertex.find_by(escape_room_id: 1) # just to get array of objects there
    # TEST
    resp = RoomServices.new.reset_room(req)
    # ASSERT that acorrect response is received
    assert resp.success
  end

  test 'no authorisation room reset' do
    req = ResetEscapeRoomRequest.new nil, 1 # auth is trivial in here
    before_test = Vertex.find_by(escape_room_id: 1) # just to get array of objects there
    # TEST
    resp = RoomServices.new.reset_room(req)
    # ASSERT that acorrect response is received
    assert_not resp.success
  end

  def test_remove_vertex_null_request
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError){ rs.remove_vertex(req) }

    assert_equal('removeVertexRequest null', exception.message)
  end

  def test_disconnect_vertices
    from_vertex = Vertex.find_by_id(1)
    req = DisconnectVerticesRequest.new(1, 2)
    rs = RoomServices.new
    rs.disconnect_vertices(req)

    assert_nil(from_vertex.vertices.find_by_id(2))
  end

  def test_disconnect_vertices_null_request
    rs = RoomServices.new
    exception = assert_raise(StandardError){ rs.disconnect_vertices(nil) }
    assert_equal('disconnect_vertices_request null', exception.message)
  end

  def test_disconnect_vertices_from_vertex_not_exist
    req = DisconnectVerticesRequest.new(100, 1)
    rs = RoomServices.new
    res = rs.disconnect_vertices(req)

    assert_equal(res.message, 'From vertex could not be found')
  end

  def test_disconnect_vertices_no_link

    req = DisconnectVerticesRequest.new(3, 1)
    rs = RoomServices.new
    res = rs.disconnect_vertices(req)

    assert_equal(res.message, 'There is no link between vertices')
  end

  def test_disconnect_vertices_correct_response
    req = DisconnectVerticesRequest.new(1, 2)
    rs = RoomServices.new
    res = rs.disconnect_vertices(req)

    assert_equal(res.success, true)
  end

  def test_update_vertex_correct
    vertexID = 1
    posX = 10
    posY = 11
    width = 25
    height = 26

    req = UpdateVertexRequest.new(vertexID, posX, posY, width, height)
    rs = RoomServices.new
    res = rs.update_vertex(req)

    vertex = Vertex.find_by_id(vertexID)

    assert_equal(res.success, true)
    assert_equal(vertex.posx, posX)
    assert_equal(vertex.posy, posY)
    assert_equal(vertex.height, height)
    assert_equal(vertex.width, width)
  end

  def test_update_vertex_nil
    rs = RoomServices.new
    exception = assert_raise(StandardError){rs.update_vertex(nil) }
    assert_equal('Request null', exception.message)
  end

  def test_update_vertex_vertex_not_exist
    req = UpdateVertexRequest.new(9, 5,5, 5, 5)
    rs = RoomServices.new
    res = rs.update_vertex(req)

    assert_equal(res.success, false)
    assert_equal(res.message, 'Vertex could not be found')
  end

  def test_update_vertex_height_negative
    req = UpdateVertexRequest.new(1, 5,5, 5, -1)
    rs = RoomServices.new
    res = rs.update_vertex(req)

    vertex = Vertex.find_by_id(1)

    assert_not_equal(vertex.height, -1)
    assert_equal(res.success, false)
  end

  def test_update_vertex_width_negative
    req = UpdateVertexRequest.new(1, 5,5, -1, 1)
    rs = RoomServices.new
    res = rs.update_vertex(req)

    vertex = Vertex.find_by_id(1)

    assert_not_equal(vertex.width, -1)
    assert_equal(res.success, false)
  end

  def test_update_vertex_incorrect_types
    req = UpdateVertexRequest.new(1, '123','5', '-1', '1')
    rs = RoomServices.new
    res = rs.update_vertex(req)

    vertex = Vertex.find_by_id(1)

    assert_not_equal(vertex.posx, '123')
    assert_not_equal(vertex.posy, '5')
    assert_not_equal(vertex.height, '1')
    assert_not_equal(vertex.width, '-1')
    assert_equal(res.success, false)
  end

end
