module Api
  module V1
    class VertexController < ApplicationController
      def index
        # vertices = Vertex.all()
        vertices = Vertex.where(:escape_room_id => request.GET['roomId'])
        render json: {status: 'SUCCESS', message: 'Vertices', data: vertices}, status: :ok
      end
    end
  end
end
