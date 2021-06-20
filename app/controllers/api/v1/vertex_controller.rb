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

      def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      end

      def cors_preflight_check
        if request.method == :options
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
          headers['Access-Control-Allow-Headers'] = '*'
          headers['Access-Control-Max-Age'] = '1728000'
          render :text => '', :content_type => 'text/plain'
        end
      end


      def index
        vertices = Vertex.all
        render json: {status: 'SUCCESS', message: 'Vertices', data: vertices}, status: :ok
      end

      def show
        id=params[:roomid]

        if room == nil
          render json: {status: 'FAILED', message: 'Room might not exist'}, status: :bad_request
          return
        end

        vertices= Vertex.find_by(escape_room_id: id)
        render json: {status: 'SUCCESS', message: 'Vertices', data: vertices}, status: :ok
      rescue StandardError

        render json: {status: 'FAILED', message: 'Room might not exist'}, status: :bad_request
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
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :bad_request
          return
        end

        serv = RoomServices.new

        case type
        when 'Puzzle'

          if estimated_time.nil? || description.nil?
            render json: { status: 'FAILED', message: 'Puzzle needs name and estimated time' }, status: :bad_request
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
            ender json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :bad_request
            return
          end

          req=CreateClueRequest.new(name,posx,posy,width,height,graphicid,clue,roomid)
          res=serv.createClue(req)

        else
          render json: {status: 'FAILED', message: 'Ensure type is correct with correct parameters'}, status: :bad_request
          return
        end

        render json: {status: 'SUCCESS', message: 'Vertex:', data: "Created: #{res.success}"}, status: :ok
      rescue StandardError
        render json: {status: 'FAILED', message: 'Unspecified error'}, status: :bad_request

      end #end create

      def destroy
        id=params[:id]

        if id.nil?
          render json: { status: 'FAILED', message: 'Delete needs an id to be passed in' }, status: :bad_request
          return
        end

        serv = RoomServices.new
        req= RemoveVertexRequest.new(id)
        resp= serv.remove_vertex(req)


        unless resp.success
          render json: {status: 'FAILED', message: 'Unspecified error'}, status: :bad_request
          return
        end

        render json: {status: 'SUCCESS', message: 'Vertex:', data: "Deleted: #{id}"}, status: :ok
        rescue StandardError
          render json: {status: 'FAILED', message: 'Unspecified error'}, status: :bad_request

      end

    end
  end
end
