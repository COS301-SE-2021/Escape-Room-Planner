# rubocop:disable Metrics/ClassLength
module Api
  # v1 model definition for api calls
  module V1
    # Controller that maps http requests to functions to execute
    class VertexController < ApplicationController
      protect_from_forgery with: :null_session


    end
  end
end
