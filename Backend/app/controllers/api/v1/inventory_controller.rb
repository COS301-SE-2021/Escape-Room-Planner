# frozen_string_literal: true

require './app/Services/services_helper'
require './app/Services/InventorySubsystem/inventory_service'
require './app/Services/InventorySubsystem/Request/add_graphic_request'
require './app/Services/InventorySubsystem/Response/add_graphic_response'
require './app/Services/InventorySubsystem/Request/get_graphics_request'
require './app/Services/InventorySubsystem/Response/get_graphics_response'
require './app/Services/InventorySubsystem/Request/delete_graphic_request'
require './app/Services/InventorySubsystem/Response/delete_graphic_response'

module Api
  module V1
    # Controller for Inventory Service
    class InventoryController < ApplicationController
      protect_from_forgery with: :null_session
      @@inventory_service = InventoryService.new

      # get api/v1/inventory
      def index
        if authorise(request)
          auth_token = request.headers['Authorization1'].split(' ').last
          req = GetGraphicsRequest.new(auth_token)
          res = @@inventory_service.get_graphics(req)
          render json: { success: res.success, message: res.message, image: res.image }, status: :ok
        else
          render json: { success: false, message: 'Unauthorized' }, status: 401
        end
      end

      # POST api/v1/inventory/
      def create
        if authorise(request)
          # get auth_token to get user id
          auth_token = request.headers['Authorization1'].split(' ').last
          req = AddGraphicRequest.new(auth_token, params[:image], params[:type])
          res = @@inventory_service.add_graphic(req)
          render json: { success: res.success, message: res.message,data: res.data}, status: :ok
        else
          render json: { success: false, message: 'Unauthorized' }, status: 401
        end
      end

      # delete api/v1/inventory/:id
      def destroy
        if authorise(request)
          # get auth_token to get user id
          auth_token = request.headers['Authorization1'].split(' ').last
          req = DeleteGraphicRequest.new(auth_token, params[:id].to_i)
          res = @@inventory_service.delete_graphic(req)
          render json: { success: res.success, message: res.message }, status: :ok
        else
          render json: { success: false, message: 'Unauthorized' }, status: 401
        end
      end
    end
  end
end
