require 'minitest/autorun'
require_relative '../../app/Services/CreateKeyRequest'
require_relative '../../app/Services/CreateKeyResponse'


class CreateKeyTest < Minitest::Unit::TestCase

  def test_CreateKeyResponse
    key_test = CreateKeyResponse.new(1)
    assert_equal(1, key_test.id, "Create Key Response has not set the id correctly")
  end

  #key doesn't have data to test
  def test_CreateKeyRequest
  end
end