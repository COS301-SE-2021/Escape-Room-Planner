# frozen_string_literal: true

require 'test_helper'
require 'concurrent'

class UserControllerTest < ActionDispatch::IntegrationTest
  test 'can login with valid credentials' do
    post api_v1_user_index_path.to_s, params: {
      type: 'login',
      username: 'testUser',
      password: 'testPass'
    }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Login Successful', response['message']
  end
end
