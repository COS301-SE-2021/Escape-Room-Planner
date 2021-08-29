require './app/Services/services_helper'
require './app/Services/GeneticAlgorithmSubsystem/SolvabilityServices'
require './app/Services/SolvabilitySubsystem/RequestSolvability/genetic_algorithm_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/genetic_algorithm_response'

# rubocop:disable Metrics/ClassLength
module Api
  # v1 model definition for api calls
  module V1
    # Controller that maps http requests to functions to execute
    class GeneticAlgorithmController < ApplicationController

    end
  end
end

