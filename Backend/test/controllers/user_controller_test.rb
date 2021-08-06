require 'test_helper'
require 'concurrent'

class UserControllerTest < ActionDispatch::IntegrationTest
  test 'can login with valid credentials' do
    req = RegisterUserRequest.new('test1','1235','test@',false)
    us = UserServices.new
    us.register_user(req)
    # BCrypt::Password.create
    puts User.find_by_id(2)[:password_digest]
    puts User.find_by_id(1)[:password_digest]
    post "#{api_v1_user_index_path}", params: {
      type: 'login',
      username: 'test1',
      password: '1235'
    }, as: :as_json


    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Login Successful', response['message']
    puts response['auth_token']
  end
end
