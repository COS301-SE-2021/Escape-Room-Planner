require 'test_helper'
require 'concurrent'

class UserControllerTest < ActionDispatch::IntegrationTest
  test 'login test' do
    put "#{api_v1_vertex_index_path}/1", params: {
      type: 'login',
      username: 'testUser',
      password_digest: '1234Pass'
    }, as: :as_json

    response = JSON.parse(@response.body)
    assert_response :ok
    assert_equal 'Vertex updates', response['message']
  end
end
