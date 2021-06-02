module Api
  module V1
    class RoomController < ApplicationController
      def index
        vertices = Vertex.all
        render json: {status: 'SUCCESS', message: 'Vertices', data: vertices}, status: :ok
      end
    end
  end
end
