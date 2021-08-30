require 'test_helper'
require 'concurrent'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'

class GeneticAlgorithmControllerTest < ActionDispatch::IntegrationTest
  test 'can make call to ga contoller' do
    response = authed_post_call(api_v1_genetic_algorithm_index_path, {
                                                                        linear: "med",
                                                                        dead_nodes: "med",
                                                                        room_id: 5
    })

    assert_response :success
  end
end
