# frozen_string_literal: true

require 'test_helper'
require './app/Services/user_services'
class UserTest < ActiveSupport::TestCase
  test 'test register user' do
    before_test = User.count
    req = RegisterUserRequest.new('rTest', 'rTest', 'rTest@gmail.com', false)
    us = UserServices.new
    us.register_user(req)

    assert_not_equal(User.count, before_test)
  end

  test 'test a user saves' do
    req = RegisterUserRequest.new('rTest', 'rTest', 'rTest@gmail.com', false)
    us = UserServices.new
    resp = us.register_user(req)

    assert(resp.success)
  end

  test 'test register user with a null request' do
    req = nil
    us = UserServices.new
    resp = us.register_user(req)

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

  test 'teset null request reset password notification' do
    req = ResetPasswordNotificationRequest.new(nil)
    us = UserServices.new
    resp = us.reset_password_notification(req)

    assert_equal(false, resp.success)
  end

  test 'test reset password notification given valid email' do
    req = ResetPasswordNotificationRequest.new('test@gmail.com')
    us = UserServices.new
    resp = us.reset_password_notification(req)

    assert(resp.success)

  end

  test 'test reset password notification given an invalid email' do
    req = ResetPasswordNotificationRequest.new('other@gmail.com')
    us = UserServices.new
    resp = us.reset_password_notification(req)

    assert_equal(false, resp.success)
  end

  test 'test password reset' do
    req = ResetPasswordRequest.new('testUser', '12345')
    us = UserServices.new
    resp = us.reset_password(req)

    assert(resp.success)
  end

  test 'test null request reset password' do
    req = ResetPasswordRequest.new(nil, nil)
    us = UserServices.new
    resp = us.reset_password(req)

    assert_equal(false, resp.success)
  end

  test 'test invalid username reset password' do
    req = ResetPasswordRequest.new('rando', '12345')
    us = UserServices.new
    resp = us.reset_password(req)

    assert_equal(false, resp.success)
  end

  test 'test sending null token to authenticate user' do
    us = UserServices.new
    assert_equal(false, us.authenticate_user(nil, 'testUser'))
  end

  test 'test sending invalid token to authenticate user' do
    us = UserServices.new
    assert_equal(false, us.authenticate_user('1234.1234.1234', 'testUser'))
  end
  # test 'test sending expired token to authenticate user' do
  #   #please note the exp in json_web_token must be changed to do the test 30 seconds
  #   req = RegisterUserRequest.new('rTest', 'rTest', 'rTest@gmail.com', false)
  #   us = UserServices.new
  #   us.register_user(req)
  #   req2 = LoginRequest.new('rTest', 'rTest')
  #   resp = us.login(req2)
  #   u = User.find_by_username('rTest')
  #   token = u.jwt_token
  #
  #   sleep(40.seconds)
  #   assert_equal(false, us.authenticate_user(token))
  # end
end
