require 'test_helper'

class ContainerTest < ActiveSupport::TestCase

  def test_createContainer

    beforetest = Container.count
    room = EscapeRoom.new
    room.save
    roomID = room.id
    req = CreateContainerRequest.new
    req.roomID = roomID
    req.graphicid = 'test'
    req.height = 0
    req.width = 0
    req.posx = 0
    req.posy = 0
    rs = RoomServices.new
    rs.createContainer(req)

    assert_not_equal(Container.count, beforetest)
  end

  def test_checkCreateContainerSaved

    room = EscapeRoom.new
    room.save
    roomID = room.id
    req = CreateContainerRequest.new
    req.roomID = roomID
    req.graphicid = 'test'
    req.height = 0
    req.width = 0
    req.posx = 0
    req.posy = 0
    rs = RoomServices.new
    resp = rs.createContainer(req)

    assert_not_equal(resp.id, 0)
  end

  def test_checkCreateContainerNullRequest
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError){rs.createContainer(req)}
    assert_equal("CreatePuzzleRequest null", exception.message)
  end

end