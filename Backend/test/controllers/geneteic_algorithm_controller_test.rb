# frozen_string_literal: true

require 'test_helper'
require 'concurrent'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'

class GeneticAlgorithmControllerTest < ActionDispatch::IntegrationTest
  # test 'can make call to ga contoller' do
  #   response = authed_post_call(api_v1_genetic_algorithm_index_path, {
  #                                                                       linear: "med",
  #                                                                       dead_nodes: "med",
  #                                                                       room_id: 6,
  #                                                                       num_containers: 2,
  #                                                                       num_clues: 2,
  #                                                                       num_keys: 2,
  #                                                                       num_puzzles: 2
  #   })
  #
  #   assert_response :success
  #end
end
