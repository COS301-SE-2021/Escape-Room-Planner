require './app/Services/create_puzzle_request'
require './app/Services/create_puzzle_response'
require './app/Services/create_container_response'
require './app/Services/create_container_request'
require './app/Services/create_key_request'
require './app/Services/create_key_response'
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

        name = params[:name] 

        graphicid = params[:graphicid] 

        posy = params[:posy] 

        posx = params[:posx] 

        width = params[:width] 

        height = params[:height] 
        
        estimated_time = params[:estimated_time]
        
        description = params[:description]

        roomid= params[:roomid]

        if name.nil? || graphicid.nil? || posy.nil? || posx.nil? || width.nil? || height.nil? || roomid.nil?
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
          return
        end

        serv = RoomServices.new

        case type
        when 'Puzzle'

          if estimated_time.nil? || description.nil?
            render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
            return
          end

          req = CreatePuzzleRequest.new(name,posx,posy,width,height,graphicid,estimated_time,description,roomid)
          res = serv.createPuzzle(req)

        when 'Key'
          req = CreateKeyRequest.new(name,posx,posy,width,height,graphicid,roomid)
          res = serv.createKey(req)
        else
          render json: {status: 'FAILED', message: 'Ensure type is correct with correct parameters'}, status: :not_found
          return
        end

        render json: {status: 'SUCCESS', message: 'Vertex:', data: "Created: #{res.success}"}, status: :ok
      rescue StandardError
        render json: {status: 'FAILED', message: 'Unspecified error'}, status: :not_found
        
      end
    end
  end
end
