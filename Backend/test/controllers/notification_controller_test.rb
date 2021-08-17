require 'test_helper'
require 'concurrent'

class NotificationControllerTest < ActionDispatch::IntegrationTest

  test "can call reset password" do
      response = authed_post_call(api_v1_notification_index_path, { operation: 'Reset Password',
                                                                    email: "Patrice02052@gmail.com"})

      assert_response :success
  end

  test "call reset password with no email" do
    response = authed_post_call(api_v1_notification_index_path, { operation: 'Reset Password'})

    assert_response :bad_request
  end

end