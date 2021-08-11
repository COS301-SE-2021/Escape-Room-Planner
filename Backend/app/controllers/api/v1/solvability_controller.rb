require './app/Services/services_helper'

# rubocop:disable Metrics/ClassLength
module Api
  # v1 model definition for api calls
  module V1
    # Controller that maps http requests to functions to execute
    class VertexController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        if authorise(request)
          startVert = params[:startVertex]

          endVert = params[:endVertex]

          vertices = params[:vertices]

        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      end

    end
  end
end
