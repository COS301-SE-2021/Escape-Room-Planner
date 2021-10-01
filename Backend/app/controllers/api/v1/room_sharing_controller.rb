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

      def create
        if params[:operation].nil?
          render json: { status: 'Failed', message: 'Specify operation' }, status: :bad_request
          return
        end

        if params[:operation] == 'addPublic'
          if params[:roomID].nil?
            render json: { status: 'Failed', message: 'RoomID cannot be null' }, status: :bad_request
            return
          end

          room = PublicRoom.new
          room.RoomID = params[:roomID]
          if room.save!
            render json: { status: 'Success', message: 'Room added to public' }, status: :ok
          else
            render json: { status: 'Failed', message: 'could not add room' }, status: :bad_request
          end
        end

        if params[:operation] == 'removePublic'
          room = PublicRoom.find_by(RoomID: params[:roomID])
          if room.destroy
            render json: { status: 'Success', message: 'RoomDestroyed' }, status: :ok
          else
            render json: { status: 'Failed', message: 'could not destroy room' }, status: :bad_request
          end
        end

        if params[:operation] == 'addRating'
          rating = RoomRating.new(RoomID: params[:roomID], Rating: params[:rating])
          if rating.save
            render json: { status: 'Success', message: 'Room Rating Added' }, status: :ok
          else
            render json: { status: 'Failed', message: 'could not save room' }, status: :bad_request
          end

        end
      rescue StandardError
        render json: { success: false, message: 'System Error' }, status: 500
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
