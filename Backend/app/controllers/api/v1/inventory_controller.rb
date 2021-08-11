require './app/Services/services_helper'

class Api::V1::InventoryController < ApplicationController
  protect_from_forgery with: :null_session
  def create
    if authorise(request)
      render json: { status: 'SUCCESS', message: 'Escape Rooms', data: "WORK" }, status: :ok
    else
      render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
    end
  end
end
