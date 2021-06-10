require 'test_helper'

class ContainerTest < ActiveSupport::TestCase

  def test_createContainer

    beforetest = Container.count
    roomID = 1
    req = CreateContainerRequest.new(0, 0, 0.1, 0.1, "test", roomID, "d")
    rs = RoomServices.new
    rs.createContainer(req)

    assert_not_equal(Container.count, beforetest)
  end

  def test_checkCreateContainerNullRequest
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError){rs.createContainer(req)}
    assert_equal("CreateContainerRequest null", exception.message)
  end

end