module Api
  module V1
    class RoomController < ApplicationController
      def index
        rooms = EscapeRoom.all
        render json: {status: 'SUCCESS', message: 'Vertices', data: rooms}, status: :ok
      end
    end
  end
end
