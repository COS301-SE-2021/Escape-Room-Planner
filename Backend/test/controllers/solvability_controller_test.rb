require 'test_helper'
require 'concurrent'

class SolvabilityControllerTest < ActionDispatch::IntegrationTest
  test 'can make call to check if escape room is solvable' do
     # authed_post_call(api_v1_solvability_index_path, { operation: 'Solvable',
     #                                                   startVertex: '1',
     #                                                   endVertex: '6',
     #                                                   vertices: '[1, 2, 3, 4, 5, 6]'})
     # assert_response :success
  end
end
