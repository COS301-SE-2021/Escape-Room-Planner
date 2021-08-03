# frozen_string_literal: true

require './app/Services/create_puzzle_request'
require './app/Services/create_puzzle_response'
require './app/Services/create_container_response'
require './app/Services/create_container_request'
require './app/Services/create_key_request'
require './app/Services/create_key_response'
require './app/Services/room_services'
require './app/Services/remove_vertex_request'
require './app/Services/remove_vertex_response'
require './app/Services/update_vertex_request'
require './app/Services/update_vertex_response'

# rubocop:disable Metrics/ClassLength
module Api
  # v1 model definition for api calls
  module V1
    # Controller that maps http requests to functions to execute
    class VertexController < ApplicationController
      protect_from_forgery with: :null_session

      # userService instance to be used for authorization
      @@user_service = UserServices.new

      # PUT request http://host:port/api/v1/vertex/vertex_id, json
      # @return [JSON object with a status code or error message]
      def update
        # checks if user is authorized 
        if request.headers['Authorization'].present?
          auth_token = request.headers['Authorization'].split(' ').last
          unless @@user_service.authenticateUser(auth_token)
            render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
            return
          end

          # operation parameter tells what put operation should be done on vertex
          operation = params[:operation]

          case operation
          when 'connection'
            update_connection(params[:from_vertex_id], params[:to_vertex_id])
          when 'transformation'
            update_transformation(params[:id], params[:pos_x], params[:pos_y], params[:width], params[:height])
          else
            render json: { status: 'FAILED', message: 'Operation does not exist' }, status: :bad_request
          end
        end
      end

      # @param [ActionController::Parameters] id
      # @param [ActionController::Parameters] pos_x
      # @param [ActionController::Parameters] pos_y
      # @param [ActionController::Parameters] width
      # @param [ActionController::Parameters] height
      # @return JSON
      def update_transformation(id, pos_x, pos_y, width, height)
        # used as update method that does transformation updates
        # todo remake the tests, and add extra ones
        if id.nil? || pos_y.nil? || pos_x.nil? || width.nil? || height.nil?
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :bad_request
          return
        end

        req = UpdateVertexRequest.new(id, pos_x, pos_y, width, height)
        serv = RoomServices.new
        resp = serv.update_vertex(req)

        unless resp.success
          render json: { status: 'FAILED', message: 'Vertex might not exist', data: resp }, status: :ok
          return
        end
        render json: { status: 'SUCCESS', message: 'Vertex updates', data: resp }, status: :ok
      rescue StandardError
        render json: { status: 'FAILED', message: 'Vertex might not exist' }, status: :bad_request
      end

      # calls service to connect two vertices
      # @param [ActionController::Parameters] from_vertex_id
      # @param [ActionController::Parameters] to_vertex_id
      def update_connection(from_vertex_id, to_vertex_id)
        # use both ids and hope for the best it woks out on .save
        if from_vertex_id.nil? || to_vertex_id.nil?
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :bad_request
        else
          req = ConnectVerticesRequest.new(from_vertex_id, to_vertex_id)
          serv = RoomServices.new
          resp = serv.connect_vertex(req)

          unless resp.success
            render json: { status: 'FAILED', message: 'Could not connect vertex', data: resp }, status: :ok
            return
          end

          render json: { status: 'SUCCESS', message: 'Vertex connection updates', data: resp }, status: :ok
        end
      rescue StandardError
        render json: { status: 'FAILED', message: 'Internal Error' }, status: :bad_request
      end

      def index
        vertices = Vertex.all
        render json: { status: 'SUCCESS', message: 'Vertices', data: vertices }, status: :ok
      end

      def show
        id = params[:id]

        if EscapeRoom.find_by(id: id).nil?
          render json: { status: 'FAILED', message: 'Room might not exist' }, status: :bad_request
          return
        end

        vertices = Vertex.where(escape_room_id: id)
        render json: { status: 'SUCCESS', message: 'Vertices', data: vertices }, status: :ok
      rescue StandardError
        render json: { status: 'FAILED', message: 'Room might not exist' }, status: :bad_request
      end

      # POST api/v1/vertex
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

        clue = params[:clue]

        roomid = params[:roomid]

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

          req = CreatePuzzleRequest.new(name, posx, posy, width, height, graphicid, estimated_time, description, roomid)
          res = serv.create_puzzle(req)

        when 'Key'
          req = CreateKeyRequest.new(name, posx, posy, width, height, graphicid, roomid)
          res = serv.create_key(req)

        when 'Container'
          req = CreateContainerRequest.new(posx, posy, width, height, graphicid, roomid, name)
          res = serv.create_container(req)

        when 'Clue'
          if clue.nil?
            render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :bad_request
            return
          end

          req = CreateClueRequest.new(name, posx, posy, width, height, graphicid, clue, roomid)
          res = serv.create_clue(req)

        else
          render json: { status: 'FAILED', message: 'Ensure type is correct with correct parameters' }, status: :ok
          return
        end

        render json: { status: 'SUCCESS', message: 'Vertex:', data: res }, status: :ok
      rescue StandardError
        render json: { status: 'FAILED', message: 'Unspecified error' }, status: :bad_request
      end
      # end create

      def destroy
        id = params[:id]

        if id.nil?
          render json: { status: 'FAILED', message: 'Delete needs an id to be passed in' }, status: :bad_request
          return
        end

        serv = RoomServices.new
        req = RemoveVertexRequest.new(id)
        resp = serv.remove_vertex(req)

        unless resp.success
          render json: { status: 'FAILED', message: 'Unspecified error', data: resp }, status: :ok
          return
        end

        render json: { status: 'SUCCESS', message: 'Vertex:', data: "Deleted: #{id}" }, status: :ok
      rescue StandardError
        render json: { status: 'FAILED', message: 'Unspecified error' }, status: :bad_request
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
