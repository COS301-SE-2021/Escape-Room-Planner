require './app/Services/room_services'


module Api
  module V1
    class RoomController < ApplicationController
      protect_from_forgery with: :null_session

      # GET api/v1/room , shows all the rooms in db
      def index
        rooms = EscapeRoom.select(:id, :name)
        render json: { status: 'SUCCESS', message: 'Escape Rooms', data: rooms }, status: :ok
      end

      # GET api/v1/room/id , returns a room by id
      def show
        begin
          # TODO: this should be a user_id or jwt token that will be decoded
          room = EscapeRoom.select(:id, :name).find(params[:id])
          render json: { status: 'SUCCESS', message: 'Escape Rooms', data: room }, status: :ok
        rescue StandardError
          render json: { status: 'Fail', message: 'Escape Room might not exist' }, status: :not_found
        end
      end

      # POST api/v1/room, creates a new room
      def create
        require './app/Services/create_escaperoom_request'
        require './app/Services/create_escaperoom_response'

        req = CreateEscapeRoomRequest.new(params[:name])
        serv = RoomServices.new
        resp = serv.create_escape_room(req)

        render json: { status: 'SUCCESS', message: 'Added room id:', data: resp }, status: :ok
      end
    end
  end
end
