# frozen_string_literal: true

require './app/Services/room_services'
require './app/Services/services_helper'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'
require './app/Services/RoomSubsystem/Request/get_rooms_request'
require './app/Services/RoomSubsystem/Response/get_rooms_response'

module Api
  module V1
    class RoomController < ApplicationController
      protect_from_forgery with: :null_session
      # GET api/v1/room , shows all the rooms in db
      def index
        if authorise(request)
          auth_token = request.headers['Authorization1'].split(' ').last
          req = GetRoomsRequest.new(auth_token)
          serv = RoomServices.new
          resp = serv.get_rooms(req)
          render json: { status: resp.success, message: resp.message, data: resp.data }, status: :ok
        else
          render json: { status: false, message: 'Unauthorized' }, status: 401
        end
      end

      # GET api/v1/room/id , returns a room by id
      def show
        if authorise(request)
          room = EscapeRoom.select(:id, :name, :startVertex, :endVertex).find(params[:id])
          render json: { status: 'SUCCESS', message: 'Escape Rooms', data: room }, status: :ok
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      rescue StandardError
        render json: { status: 'Fail', message: 'Escape Room might not exist' }, status: :not_found
      end

      # POST api/v1/room, creates a new room
      def create
        if authorise(request)
          auth_token = request.headers['Authorization1'].split(' ').last
          req = CreateEscapeRoomRequest.new(params[:name], auth_token)
          serv = RoomServices.new
          resp = serv.create_escape_room(req)
          render json: { status: 'SUCCESS', message: 'Added room id:', data: resp }, status: :ok
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      end

      # delete api call http://host/api/v1/room/"+room_id
      def destroy
        if authorise(request)
          room = EscapeRoom.find_by_id(params[:id])
          if room.nil?
            render json: { status: 'SUCCESS', message: 'Room does not exist' }, status: :bad_request
            return
          end
          render json: { status: 'SUCCESS', message: 'Deleted Room' }, status: :ok if room.destroy
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      end

      def update
        if params[:operation].nil?
          render json: { status: 'Failed', message: 'Specify operation' }, status: :bad_request
          return
        end

        if params[:operation] == 'setStart'

          if params[:id].nil? || params[:startVertex].nil?
            render json: { status: 'Failed', message: 'Ensure fields are filled in' }, status: :bad_request
            return
          end

          room = EscapeRoom.find_by_id(params[:id])
          room.startVertex = params[:startVertex]
          room.save!

          render json: { status: 'Success', message: 'Start vertex saved' }, status: :ok
        end

        if params[:operation] == 'setEnd'

          if params[:id].nil? || params[:endVertex].nil?
            render json: { status: 'Failed', message: 'Ensure fields are filled in' }, status: :bad_request
            return
          end

          room = EscapeRoom.find_by_id(params[:id])
          room.endVertex = params[:endVertex]
          room.save

          render json: { status: 'Success', message: 'End vertex saved' }, status: :ok
        end
      rescue StandardError
        render json: { status: 'Fail', message: 'Escape Room might not exist' }, status: :not_found
      end
    end
  end
end
