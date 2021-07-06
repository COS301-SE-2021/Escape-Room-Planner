# frozen_string_literal: true

require 'test_helper'
require './app/Services/room_services'
require './app/Services/create_escapeRoom_request'
require './app/Services/create_escapeRoom_response'

class ErTest < ActiveSupport::TestCase

  # test if escape room can be made (good case)
  test 'test create escape room' do
    before_test = EscapeRoom.count
    req = CreateEscapeRoomRequest.new('test name')
    rs = RoomServices.new
    rs.create_escape_room(req)

    assert_not_equal(EscapeRoom.count, before_test)
  end

  # test if service returns an exception (bad case)
  test 'test create escape room with null request' do
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError) { rs.create_escape_room(req) }
    assert_equal('CreateEscapeRoomRequest null', exception.message)
  end

  # test if the service returns correct response on success (good case)
  test 'can remove a vertex' do
    before_test = Vertex.count
    req = RemoveVertexRequest.new(1)
    rs = RoomServices.new
    res = rs.remove_vertex(req)

    assert_not_equal(Vertex.count, before_test)
    assert_equal(res.success, true)
  end

  # test if the service return a correct response on failure (bad case)
  test 'does\'t remove non-existent vertex' do
    req = RemoveVertexRequest.new(6) # send vertex id that doesn't exist
    rs = RoomServices.new
    res = rs.remove_vertex(req)

    assert_equal(res.success, false)
  end

  # test if the service can remove deleted vertex's connection (good case)
  test 'can remove vertices\' connection on delete' do
    vertex = Vertex.find(1)
    before_test = vertex.vertices.count
    req = RemoveVertexRequest.new(1)
    rs = RoomServices.new
    rs.remove_vertex(req)

    assert_not_equal(before_test, 0)
    assert_equal(vertex.vertices.count, 0)
  end

  # test if a room can be reset (all vertices deleted) (good case)
  test 'room does reset' do
    req = ResetEscapeRoomRequest.new 1234, 1 # auth is trivial until it is implemented
    # TEST
    RoomServices.new.reset_room(req)
    # ASSERT that a correct response is received
    assert_nil Vertex.find_by(escape_room_id: 1)
  end

  # test if a room is not removed when no authorization is provided (bad case)
  test 'room isn\'t reset without authorization' do
    req = ResetEscapeRoomRequest.new nil, 1 # auth is trivial in here, so nil will do as well
    # TEST
    RoomServices.new.reset_room(req) # don't need a response to check
    # ASSERT that a room wasn't deleted
    # works because there is only one vertex attached to the room id of 1
    assert_not_nil Vertex.find_by(escape_room_id: 1)
  end

  # test if a response is received without giving it a request object (bad case)
  test 'can handle nil request object on remove vertex case' do
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError) { rs.remove_vertex(req) }

    assert_equal('removeVertexRequest null', exception.message)
  end

  # test if we can remove the vertex connections from a join table (good case)
  test 'can disconnect vertices' do
    from_vertex = Vertex.find_by_id(1)
    req = DisconnectVerticesRequest.new(1, 2)
    rs = RoomServices.new
    rs.disconnect_vertices(req)

    assert_nil(from_vertex.vertices.find_by_id(2))
  end

  # test if a correct response is sent when nil request object is passed (bad case)
  test 'can handle nil request object on disconnect vertex case' do
    rs = RoomServices.new
    exception = assert_raise(StandardError) { rs.disconnect_vertices(nil) }
    assert_equal('disconnect_vertices_request null', exception.message)
  end

  # test if the service can't remove a connection when from vertex doesn't exist (bad case)
  test 'does\'t remove a vertex connection when vertex does not exist' do
    req = DisconnectVerticesRequest.new(100, 1)
    rs = RoomServices.new
    res = rs.disconnect_vertices(req)

    assert_equal(res.message, 'From vertex could not be found')
  end

  # test if no connections are removed when no connection exists (bad case)
  test 'does not disconnect connection when it does not exist' do
    req = DisconnectVerticesRequest.new(3, 1)
    rs = RoomServices.new
    res = rs.disconnect_vertices(req)

    assert_equal(res.message, 'There is no link between vertices')
  end

  # test if service returns a correct response when correct vertices are disconnected (good case)
  test 'can disconnect vertices' do
    req = DisconnectVerticesRequest.new(1, 2)
    rs = RoomServices.new
    res = rs.disconnect_vertices(req)

    assert_equal(res.success, true)
  end

  # test if a vertex is update correctly when a service is used (good case)
  test 'can update vertex position' do
    vertex_id = 1
    pos_x = 10
    pos_y = 11
    width = 25
    height = 26

    req = UpdateVertexRequest.new(vertex_id, pos_x, pos_y, width, height)
    rs = RoomServices.new  # creates a room service object to test it's functionality
    res = rs.update_vertex(req)

    vertex = Vertex.find_by_id(vertex_id)

    assert_equal(res.success, true)
    assert_equal(vertex.posx, pos_x)
    assert_equal(vertex.posy, pos_y)
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
