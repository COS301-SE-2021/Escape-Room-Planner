# frozen_string_literal: true

require './app/Services/room_services'
require './app/Services/services_helper'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'
require './app/Services/RoomSubsystem/Request/get_rooms_request'
require './app/Services/RoomSubsystem/Response/get_rooms_response'
require './app/Services/SolvabilitySubsystem/RequestSolvability/calculate_estimated_time_request'
require './app/Services/SolvabilitySubsystem/ResponseSolvability/calculate_estimated_time_response'
require './app/Services/SolvabilitySubsystem/SolvabilityServices'
require './app/Services/PublicRoomsSubsystem/public_rooms_service'
require './app/Services/PublicRoomsSubsystem/Response/get_public_rooms_response'
require './app/Services/PublicRoomsSubsystem/Request/add_public_room_request'
require './app/Services/PublicRoomsSubsystem/Response/add_public_room_response'
require './app/Services/PublicRoomsSubsystem/Request/remove_public_room_request'
require './app/Services/PublicRoomsSubsystem/Response/remove_public_room_response'

module Api
  module V1
    class RoomSharingController < ApplicationController
      protect_from_forgery with: :null_session
      @@serv = PublicRoomServices.new
      # Get vertices
      def index
        resp = @@serv.public_rooms
        render json: { success: resp.success, message: resp.message, data: resp.data }, status: :ok
      end

      # post request to create operations
      def create
        operation = params[:operation]
        case operation
        when 'add_public'
          if authorise(request)
            auth_token = request.headers['Authorization1'].split(' ').last
            req = AddPublicRoomRequest.new(auth_token, params['escape_room_id'])
            resp = @@serv.add_public_room(req)
            render json: { success: resp.success, message: resp.message }, status: :ok
          end
        else
          render json: { success: false, message: 'Operation does not exist' }, status: :bad_request
        end

        if params[:operation] == 'addRating'
          if (params[:roomID].nil? || params[:rating] || params[:token].nil?)
            render json: { status: 'FAILED', message: 'Empty Values' }, status: :bad_request
          end

          req = AddRatingRequest(params[:roomID], params[:token], params[:rating])
          resp = @@serv.add_rating(req)

          if(resp.success)
            render json: { status: 'SUCCESS', message: resp.message }, status: :ok
          else
            render json: { status: 'FAILED', message: resp.message }, status: :bad_request
          end
        end
      rescue StandardError
        render json: { success: false, message: 'System Error' }, status: 500
      end

      # delete api call to remove room
      def destroy
        operation = params[:operation]
        case operation
        when 'remove_public'
          if authorise(request)
            auth_token = request.headers['Authorization1'].split(' ').last
            req = RemovePublicRoomRequest.new(auth_token, params['escape_room_id'])
            resp = @@serv.add_public_room(req)
            render json: { success: resp.success, message: resp.message }, status: :ok
          end
        else
          render json: { success: false, message: 'Operation can not be preformed' }, status: :bad_request
        end
      end

      def show
        room = PublicRoom.find_by(RoomID: params[:RoomID])
        if room.nil?
          render json: { status: 'Failed', message: 'Room needs to be public' }, status: :bad_request
          return
        end

        req = GetVerticesRequest.new(params[:RoomID])
        serv = RoomServices.new
        res = serv.get_vertices(req)
        render json: { success: res.success, message: res.message, data: res.data }, status: :ok
      end
    end
  end
end
