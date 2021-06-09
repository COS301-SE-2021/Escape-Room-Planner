require './app/Services/create_puzzle_request'
require './app/Services/create_puzzle_response'
require './app/Services/room_services'
module Api
  module V1
    class VertexController < ApplicationController
      protect_from_forgery with: :null_session
      def index
        vertices = Vertex.all
        render json: {status: 'SUCCESS', message: 'Vertices', data: vertices}, status: :ok
      end

      def create
        
        type = params[:type]

        name=params[:name] unless params[:name].nil?

        graphicid=params[:graphicid] unless params[:graphicid].nil?

        posy=params[:posy] unless params[:posy].nil?

        posx=params[:posx] unless params[:posx].nil?

        width=params[:width] unless params[:width].nil?

        height=params[:height] unless params[:height].nil?



        case type
        when 'Puzzle'
          req = CreatePuzzleRequest.new
          serv  = RoomServices.new
          res=serv.createPuzzle(req)
        else
          render json: {status: 'FAILED', message: 'Ensure type is correct with correct parameters'}, status: :not_found
        end

        render json: {status: 'SUCCESS', message: 'Vertex:', data: "Created: #{res.success}"}, status: :ok
      rescue StandardError
        render json: {status: 'FAILED', message: 'Unspecified error'}, status: :not_found
        
      end
    end
  end
end
