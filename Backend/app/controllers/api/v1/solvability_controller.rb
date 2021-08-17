require './app/Services/services_helper'
require './app/Services/SolvabilitySubsystem/SolvabilityServices'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_solvabily_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_solvability_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_set_up_order_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_set_up_order_response'

# rubocop:disable Metrics/ClassLength
module Api
  # v1 model definition for api calls
  module V1
    # Controller that maps http requests to functions to execute
    class SolvabilityController < ApplicationController
      protect_from_forgery with: :null_session

      def create
        #if authorise(request)

          operation = params[:operation]

          if operation == 'Solvable'

            room_id = params[:roomid]
            start_vert = EscapeRoom.find_by_id(room_id).startVertex
            end_vert  = EscapeRoom.find_by_id(room_id).endVertex

            all = Vertex.all.where(escape_room_id: room_id)
            icount = 0
            vertices = []
            all.each do |v|
              vertices[icount] = v.id
              icount += 1
            end

            solvability(start_vert, end_vert, vertices)

          end

          if operation == 'Setup'
            room_id = params[:roomid]
            start_vert = EscapeRoom.find_by_id(room_id).startVertex
            end_vert  = EscapeRoom.find_by_id(room_id).endVertex

            all = Vertex.all.where(escape_room_id: room_id)
            icount = 0
            vertices = []
            all.each do |v|
              vertices[icount] = v.id
              icount += 1
            end

            set_up_order(start_vert, end_vert, vertices)
          end

        #  else
        # render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        #end
      rescue StandardError
        render json: { status: 'FAILED', message: 'Unspecified error' }, status: :bad_request
      end

      def solvability(start_vert, end_vert, vertices)
        if start_vert.nil? || end_vert.nil? || vertices.nil?
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :bad_request
          return
        end

        req = CalculateSolvableRequest.new(start_vert, end_vert, vertices)
        serv = SolvabilityService.new
        resp = serv.calculate_solvability(req)


        render json: { status: 'Response received', message: 'Data:', data: resp }, status: :ok
      end

      def set_up_order(start_vert, end_vert, vertices)
        if start_vert.nil? || end_vert.nil? || vertices.nil?
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :bad_request
          return
        end

        req = CalculateSetUpOrderRequest.new(start_vert,end_vert,vertices)
        serv = SolvabilityService.new
        resp = serv.calculate_set_up_order(req)

        render json: { status: 'Response received', message: 'Data:', data: resp }, status: :ok
      end
    end

  end
end

