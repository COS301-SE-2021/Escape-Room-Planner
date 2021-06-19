require './app/Services/create_puzzle_request'
require './app/Services/create_puzzle_response'
require './app/Services/create_container_response'
require './app/Services/create_container_request'
require './app/Services/create_key_request'
require './app/Services/create_key_response'
require './app/Services/room_services'
require './app/Services/remove_vertex_request'
require './app/Services/remove_vertex_response'

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

        clue= params[:clue]

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

        when 'Container'
          req = CreateContainerRequest.new(posx,posy,width,height,graphicid,roomid,name)
          res = serv.createContainer(req)

        when 'Clue'
          if clue.nil?
            ender json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
            return
          end

          req=new CreateClueRequest.new(name,posx,posy,width,height,graphicid,clue,roomid)
          res=serv.createClue(req)

        else
          render json: {status: 'FAILED', message: 'Ensure type is correct with correct parameters'}, status: :not_found
          return
        end

        render json: {status: 'SUCCESS', message: 'Vertex:', data: "Created: #{res.success}"}, status: :ok
      rescue StandardError
        render json: {status: 'FAILED', message: 'Unspecified error'}, status: :not_found

      end #end create

      def destroy
        id=params[:id]

        if id.nil?
          render json: { status: 'FAILED', message: 'Delete needs an id to be passed in' }, status: :not_found
          return
        end
        serv = RoomServices.new
        req=new RemoveVertexRequest(id)
        resp= serv.remove_vertex(req)

        unless resp.success
          render json: {status: 'FAILED', message: 'Unspecified error'}, status: :not_found
          return
        end

        rescue StandardError
          render json: {status: 'FAILED', message: 'Unspecified error'}, status: :not_found

      end

    end
  end
end
