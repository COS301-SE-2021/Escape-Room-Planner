require './app/Services/services_helper'
require './app/Services/reset_password_notification_request'
require './app/Services/reset_password_notification_response'
require './app/Services/user_services'

module Api
  module V1
    class NotificationController < ApplicationController
      protect_from_forgery with: :null_session

      def create
        if authorise(request)
          operation = params[:operation]

          if operation == "Reset Password"
            if params[:email].nil?
              render json: { status: 'FAILED', message: 'No email received' }, status: 400
              return
            end

          end
        else
          render json: { status: 'FAILED', message: 'Unauthorized' }, status: 401
        end
      end

      def ResetPassword(email)

      end

    end
  end
end

