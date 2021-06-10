require 'test_helper'
require './app/Services/room_services'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'



class ErTest < ActiveSupport::TestCase

  def test_createEscapeRoom

    beforetest=EscapeRoom.count
    req = CreateEscaperoomRequest.new
    rs = RoomServices.new
    rs.createEscapeRoom(req)

    assert_not_equal(EscapeRoom.count, beforetest)
  end

  def test_checkCreateEscapeRoomSaved
    req = CreateEscaperoomRequest.new
    rs = RoomServices.new
    resp = rs.createEscapeRoom(req)

    assert_not_equal(resp.id, 0)
  end

  def test_checkCreateEscapeRoomNullRequest
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError){rs.createEscapeRoom(req)}
    assert_equal("CreateEscaperoomRequest null", exception.message)
  end

  def test_removeVertex

    beforetest= Vertex.count
    req = RemoveVertexRequest.new(1)
    rs = RoomServices.new
    res = rs.removeVertex(req)

    assert_not_equal(Vertex.count, beforetest)
    assert_equal(res.success, true)
  end

  def test_removeVertexResponseFailed

    req = RemoveVertexRequest.new(6)
    rs = RoomServices.new
    res = rs.removeVertex(req)

    assert_equal(res.success, false)
  end

  def test_removeVertexVerticiesRemoved

    vertex = Vertex.find(1)
    beforetest = vertex.vertices.count
    req = RemoveVertexRequest.new(1)
    rs = RoomServices.new
    res = rs.removeVertex(req)

    assert_not_equal(beforetest, 0)
    assert_equal(vertex.vertices.count, 0)
  end

end