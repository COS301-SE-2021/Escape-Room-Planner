# frozen_string_literal: true

require './app/Services/room_services'
require './app/Services/services_helper'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'

module Api
  module V1
    class RoomController < ApplicationController
      protect_from_forgery with: :null_session
      # GET api/v1/room , shows all the rooms in db
      def index
        if authorise(request)
          rooms = EscapeRoom.select(:id, :name)
          render json: { status: 'SUCCESS', message: 'Escape Rooms', data: rooms }, status: :ok
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      end

      # GET api/v1/room/id , returns a room by id
      def show
        # TODO: this should be a user_id or jwt token that will be decoded
        if authorise(request)
          room = EscapeRoom.select(:id, :name).find(params[:id])
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
          req = CreateEscapeRoomRequest.new(params[:name])
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
    end
  end
end
