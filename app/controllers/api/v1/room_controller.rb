require './app/Services/room_services'
require './app/Services/create_escaperoom_request'
require './app/Services/create_escaperoom_response'

module Api
  module V1
    class RoomController < ApplicationController
      protect_from_forgery with: :null_session

      #Get Rooms
      def index
        rooms = EscapeRoom.all
        render json: {status: 'SUCCESS', message: 'Vertices', data: rooms}, status: :ok
      end

      #Get Room
      def show
        begin
          room= EscapeRoom.find(params[:id])
          render json: {status: 'SUCCESS', message: 'Vertex:', data: room}, status: :ok
        rescue StandardError
          render json: {status: 'Fail', message: 'Id might not exist'}, status: :not_found
        end
      end

      #Create Escape Room
      def create

        req = CreateEscaperoomRequest.new
        serv = RoomServices.new
        resp = serv.createEscapeRoom(req)

        render json: {status: 'SUCCESS', message: 'Added room id:', data: resp.id}, status: :ok
      end
    end
  end
end
