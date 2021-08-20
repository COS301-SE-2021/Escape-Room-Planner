# frozen_string_literal: true

require 'test_helper'

class ContainerTest < ActiveSupport::TestCase
  test 'test create container' do
    before_test = Container.count
    room_id = 1
    req = CreateContainerRequest.new(0, 0, 0.1, 0.1, 'test', room_id, 'd',1)
    rs = RoomServices.new
    rs.create_container(req)
    assert_not_equal(Container.count, before_test)
  end

  test 'test check create container null request' do
    req = nil
    rs = RoomServices.new
    exception = assert_raise(StandardError) { rs.create_container(req) }
    assert_equal('CreateContainerRequest null', exception.message)
  end
end
