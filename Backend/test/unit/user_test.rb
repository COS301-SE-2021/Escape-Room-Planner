require 'test_helper'
require './app/Services/user_services'
class UserTest < ActiveSupport::TestCase

  test 'test register user' do
    before_test = User.count
    req = RegisterUserRequest.new('rTest', 'rTest', 'rTest@gmail.com', false)
    us = UserServices.new
    us.registerUser(req)

    assert_not_equal(User.count, before_test)
  end

  test 'test a user saves' do
    req = RegisterUserRequest.new('TestUser', '1234Pass', 'test@gmail.com', false)
    us = UserServices.new
    resp = us.registerUser(req)

    assert(resp.success)
  end

  test 'test register user with a null request' do
    req = nil
    us = UserServices.new
    resp = us.registerUser(req)

    assert_equal(false, resp.success)
  end

  test 'test login with a valid user' do
    req = LoginRequest.new('testUser', 'testPass')
    us = UserServices.new
    resp = us.login(req)

    assert(resp.success)
  end

  test 'test login with an invalid username' do
    req = LoginRequest.new('test', 'testPass')
    us = UserServices.new
    resp = us.login(req)

    assert_equal(false, resp.success)
  end

  test 'test login with an invalid password' do
    req = LoginRequest.new('testUser', 'rando')
    us = UserServices.new
    resp = us.login(req)

    assert_equal(false, resp.success)
  end

  test 'test password reset' do
    req = ResetPasswordRequest.new('testUser', '12345')
    us = UserServices.new
    resp = us.resetPassword(req)

    assert(resp.success)
  end

end
