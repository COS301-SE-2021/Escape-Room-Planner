require 'test_helper'
class Room_Controller_test
  class ArticlesControllerTest < ActionDispatch::IntegrationTest

    test 'can get index' do
      get api_v1_room_index_path
      assert_response :success
    end

  end
end