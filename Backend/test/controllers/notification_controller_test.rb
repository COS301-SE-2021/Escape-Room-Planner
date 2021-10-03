require 'test_helper'
require 'concurrent'

class NotificationControllerTest < ActionDispatch::IntegrationTest

  test "can call reset password" do
    post api_v1_notification_index_path.to_s, params: {
      operation: 'Reset Password',
      email: 'test@gmail.com'
    }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Email sent successfully', response['message']
  end

  test "call reset password with no email" do
    post api_v1_notification_index_path.to_s, params: {
      operation: 'Reset Password'
    }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :bad_request
  end
end