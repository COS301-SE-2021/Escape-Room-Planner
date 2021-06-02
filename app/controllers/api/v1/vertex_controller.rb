module Api
  module V1
    class VertexController < ApplicationController
      def index
        vertices = Vertex.all
        render json: {status: 'SUCCESS', message: 'Vertices', data: vertices}, status: :ok
      end
    end
  end
end
