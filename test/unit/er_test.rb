require 'test_helper'
require './app/Services/room_services'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'

class ErTest < ActiveSupport::TestCase

    def test_world
      beforetest=EscapeRoom.count

      req= CreateEscaperoomRequest.new
      res= null
      rs=RoomServices.new
      rs.createEscapeRoom(req)

      assert_difference(EscapeRoom.count, beforetest)
    end
end