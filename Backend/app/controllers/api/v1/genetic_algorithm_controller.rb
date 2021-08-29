require './app/Services/services_helper'
require './app/Services/GeneticAlgorithmSubsystem/genetic_algorithm_service'
require './app/Services/GeneticAlgorithmSubsystem/Request/genetic_algorithm_request'
require './app/Services/GeneticAlgorithmSubsystem/Response/genetic_algorithm_response'

# rubocop:disable Metrics/ClassLength
module Api
  # v1 model definition for api calls
  module V1
    # Controller that maps http requests to functions to execute
    class GeneticAlgorithmController < ApplicationController
      def create

        room_id=params[:room_id]
        linear = params[:linear]
        dead_nodes = params[:dead_nodes]
        all = Vertex.all.where(escape_room_id: room_id)
        icount = 0
        vertices = []
        all.each do |v|
          vertices[icount] = v.id
          icount += 1
        end

        req = GeneticAlgorithmRequest.new(vertices, linear, dead_nodes, room_id)
        serv = GeneticAlgorithmService.new
        resp = serv.genetic_algorithm(req)

        render json: { status: 'Response received', message: 'Data:', data: resp }, status: :ok
      rescue StandardError
        render json: { status: 'FAILED', message: 'Unspecified error' }, status: :bad_request

      end
    end
  end
end

