require 'test_helper'
require '../../app/Services/user_services'
class UserTest < ActiveSupport::TestCase

  def test_registerUser
    before_test = User.count
    req = RegisterUserRequest.new('TestUser', '1234Pass', 'test@gmail.com', false)
    us = UserServices.new
    us.registerUser(req)

    assert_not_equal(User.count, before_test)
  end

end
