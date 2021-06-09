module Api
  module V1
    class VertexController < ApplicationController
      protect_from_forgery with: :null_session
      def index
        vertices = Vertex.all
        render json: {status: 'SUCCESS', message: 'Vertices', data: vertices}, status: :ok
      end

      def create
        begin
          type = params[:type]

          Puzzle.create if type == 'Puzzle'

          Container.create if type == 'Container'

          Keys.create if type == 'Key'

          Clue.create if type == 'Clue'

          render json: {status: 'SUCCESS', message: 'Vertex:', data: "Created: #{type}"}, status: :ok
        rescue StandardError
          render json: {status: 'Fail', message: 'Ensure type is correct with correct parameters'}, status: :not_found
        end
      end
    end
  end
end
