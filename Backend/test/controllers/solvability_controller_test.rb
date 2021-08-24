require 'test_helper'
require 'concurrent'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'

class SolvabilityControllerTest < ActionDispatch::IntegrationTest
  test 'can make call to check if escape room is solvable' do
    response = authed_post_call(api_v1_solvability_index_path, { operation: 'Solvable',
                                                        startVertex: 1,
                                                                 endVertex: 6,
                                                                 roomid: 1
              })

    assert_response :success
  end

  test 'can make call to check set up order' do
    response = authed_post_call(api_v1_solvability_index_path, { operation: 'Setup',
                                                                 startVertex: 1,
                                                                 endVertex: 6,
                                                                 roomid: 1})

    assert_response :success
  end

  test 'can make call to check return paths' do
    response = authed_post_call(api_v1_solvability_index_path, { operation: 'ReturnPaths',
                                                                 startVertex: 1,
                                                                 endVertex: 6,
                                                                 roomid: 1})

    assert_response :success
  end


end
