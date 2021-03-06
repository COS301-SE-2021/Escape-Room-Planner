# frozen_string_literal: true

require './app/Services/room_services'
require './app/Services/services_helper'
require './app/Services/RoomSubsystem/Request/get_rooms_request'
require './app/Services/RoomSubsystem/Response/get_rooms_response'
require './app/Services/PublicRoomsSubsystem/public_rooms_service'
require './app/Services/PublicRoomsSubsystem/Request/get_public_rooms_request'
require './app/Services/PublicRoomsSubsystem/Response/get_public_rooms_response'
require './app/Services/PublicRoomsSubsystem/Request/add_public_room_request'
require './app/Services/PublicRoomsSubsystem/Response/add_public_room_response'
require './app/Services/PublicRoomsSubsystem/Request/remove_public_room_request'
require './app/Services/PublicRoomsSubsystem/Response/remove_public_room_response'
require './app/Services/PublicRoomsSubsystem/Request/add_rating_request'
require './app/Services/PublicRoomsSubsystem/Response/add_rating_response'
require './app/Services/RoomSubsystem/Request/get_room_images.request'
require './app/Services/RoomSubsystem/Response/get_room_images.response'

module Api
  module V1
    class RoomSharingController < ApplicationController
      protect_from_forgery with: :null_session
      @@serv = PublicRoomServices.new
      # Get vertices
      def index
        req = GetPublicRoomsRequest.new(params[:search], params[:filter], nil, nil)
        resp = if authorise(request)
                 @@serv.public_rooms(req, JsonWebToken.decode(request.headers['Authorization1'].split(' ').last)['id'])
               else
                 @@serv.public_rooms(req, nil)
               end
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
        when 'add_rating'
          auth_token = request.headers['Authorization1'].split(' ').last
          req = AddRatingRequest.new(params[:roomID], auth_token, params[:rating])
          resp = @@serv.add_rating(req)
          render json: { success: resp.success, message: resp.message }, status: :ok
        else
          render json: { success: false, message: 'Operation does not exist' }, status: :bad_request
        end
      end

      # delete api call to remove room
      def destroy
        operation = params[:operation]
        case operation
        when 'remove_public'
          if authorise(request)
            auth_token = request.headers['Authorization1'].split(' ').last
            req = RemovePublicRoomRequest.new(auth_token, params['escape_room_id'])
            resp = @@serv.remove_public_room(req)
            render json: { success: resp.success, message: resp.message }, status: :ok
          end
        else
          render json: { success: false, message: 'Operation can not be preformed' }, status: :bad_request
        end
      end

      # api/v1/room_sharing/id
      # get method that will get room_images and room vertex
      def show
        room = PublicRoom.find_by_escape_room_id(params[:id])
        if room.nil?
          render json: { success: false, message: 'Room needs to be public' }, status: :bad_request
          return
        end
        room_serv = RoomServices.new
        req_vertex = GetVerticesRequest.new(params[:id])
        res_vertex = room_serv.get_vertices(req_vertex)
        req_room_images = GetRoomImagesRequest.new(params[:id])
        res_room_images = room_serv.room_images(req_room_images)
        render json: { success_vertex: res_room_images.success, message_vertex: res_vertex.message,
                       data_vertex: res_vertex.data, success_room_images: res_room_images.success,
                       message_room_images: res_room_images.message,
                       data_room_images: res_room_images.data }, status: :ok
      rescue StandardError
        render json: { success: false, message: 'Error internally' }, status: 500
      end

      # put request to update operations
      def update
        operation = params[:operation]
        case operation
        when 'set_best_time'
          resp = @@serv.set_best_time(params['escape_room_id'], params['best_time'])
          render json: { success: resp.success, message: resp.message }, status: :ok
        else
          render json: { success: false, message: 'Operation can not be preformed' }, status: :bad_request
        end
      end
    end
  end
end
