require 'minitest/autorun'

require "test/unit/assertions"
include Test::Unit::Assertions

require './app/Services/room_services'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'

class ErTest < Minitest::Unit::TestCase

    def test_world


      assert_equal 'world', hello, "Hello.world should return a string called 'world'"
    end

    def test_flunk
      flunk "You shall not pass"
    end
end


# class ErTest < Minitest::Unit::TestCase
#   def setup
#     puts 'hello'
#   end
#
#   def teardown
#     Do nothing
  # end
  #
  # def test
  #   skip 'Not implemented'
  # end
# end