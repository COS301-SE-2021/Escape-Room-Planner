# frozen_string_literal: true

require './app/Services/services_helper'
require './app/Services/InventorySubsystem/inventory_service'
require './app/Services/InventorySubsystem/Request/add_graphic_request'
require './app/Services/InventorySubsystem/Response/add_graphic_response'

module Api
  module V1
    # Controller for Inventory Service
    class InventoryController < ApplicationController
      protect_from_forgery with: :null_session
      @@inventory_service = InventoryService.new

      # POST api/v1/inventory/
      def create
        if authorise(request)
          # get auth_token to get user id
          auth_token = request.headers['Authorization'].split(' ').last
          req = AddGraphicRequest.new(auth_token, params[:image])
          res = @@inventory_service.add_graphic(req)
          render json: { success: res.success, message: res.message }, status: :ok
        else
          render json: { success: false, message: 'Unauthorized' }, status: 401
        end
      end
    end
  end
end
