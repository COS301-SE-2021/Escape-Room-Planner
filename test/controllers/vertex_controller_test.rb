require 'test_helper'
class VertexControllerTest < ActionDispatch::IntegrationTest

  test 'can get index' do
    get api_v1_vertex_index_path
    assert_response :success
  end

end
