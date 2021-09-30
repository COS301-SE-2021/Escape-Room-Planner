require './app/Services/room_services'
require './app/Services/services_helper'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'
require './app/Services/RoomSubsystem/Request/get_rooms_request'
require './app/Services/RoomSubsystem/Response/get_rooms_response'

module Api
  module V1
    class RoomSharingController < ApplicationController

      def index
        rooms = PublicRoom.all
        render json: { status: 'success', data: rooms }, status: :ok
      end

      def update
        if params[:operation].nil?
          render json: { status: 'Failed', message: 'Specify operation' }, status: :bad_request
          return
        end


        if (params[:operation] == "AddPublic")
          if params[:RoomID].nil?
            render json: { status: 'Failed', message: 'RoomID cannot be null' }, status: :bad_request
            return
          end

          room = PublicRoom.new(RoomID: params[:RoomID])
          room.save
        end

      rescue StandardError
        render json: { status: 'Fail', message: 'Unknown Error' }, status: :not_found
      end

    end
  end
end

