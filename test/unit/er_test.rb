require 'minitest/autorun'

require "test/unit/assertions"
include Test::Unit::Assertions


class ErTest < Minitest::Unit::TestCase

  def setup

  end

  def test
    hello = 'world'
    puts hello
    assert_equal 'world', hello, "hello function should return 'world'"
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