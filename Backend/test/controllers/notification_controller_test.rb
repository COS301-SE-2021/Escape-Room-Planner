require 'test_helper'
require 'concurrent'

class RoomControllerTest < ActionDispatch::IntegrationTest
  BEARER = '"Bearer '.freeze

  test"can call reset password" do
      response = authed_post_call(api_v1_notification_index_path, { operation: 'Reset Password',
                                                                    email: "Patrice02052@gmail.com"})

      assert_response :success
  end

end