require 'test_helper'
require './app/Services/user_services'
class UserTest < ActiveSupport::TestCase

  def test_registerUser
    before_test = User.count
    # req = RegisterUserRequest.new('rTest', 'rTest', 'rTest@gmail.com', false)
    req = RegisterUserRequest.new('TestUser', '1234Pass', 'test@gmail.com', false)
    us = UserServices.new
    us.registerUser(req)

    assert_not_equal(User.count, before_test)
  end

  def test_UserSave
    req = RegisterUserRequest.new('TestUser', '1234Pass', 'test@gmail.com', false)
    us = UserServices.new
    resp = us.registerUser(req)

    assert(resp.success)
  end

  def test_registerUserNullRequest
    req = nil
    us = UserServices.new
    resp = us.registerUser(req)

    assert_equal(false, resp.success)
  end

  def test_LoginWithCorrectCredentials
    req = LoginRequest.new('testUser', 'testPass')
    us = UserServices.new
    resp = us.login(req)

    assert(resp.success)
  end

  def test_LoginWithIncorrectUsername
    req = LoginRequest.new('test', 'testPass')
    us = UserServices.new
    resp = us.login(req)

    assert_equal(false, resp.success)
  end

  def test_LoginWithIncorrectPassword
    req = LoginRequest.new('test', 'rando')
    us = UserServices.new
    resp = us.login(req)

    assert_equal(false, resp.success)

  end

end
