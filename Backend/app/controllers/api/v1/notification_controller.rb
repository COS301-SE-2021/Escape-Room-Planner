require './app/Services/services_helper'
require './app/Services/reset_password_notification_request'
require './app/Services/reset_password_notification_response'
require './app/Services/user_services'

module Api
  module V1
    class NotificationController < ApplicationController
      protect_from_forgery with: :null_session

      def create
        # if authorise(request)
          operation = params[:operation]

          if operation == "Reset Password"
            if params[:email].nil?
              render json: { status: 'FAILED', message: 'No email received' }, status: 400
              return

              else
                resp = reset_password(params[:email])
                render json: { status: 'Response received', message: 'Data:', data: resp }, status: :ok
              end

          end
      end

      def reset_password(email)
        req = ResetPasswordNotificationRequest.new(email)
        serv = UserServices.new
        serv.reset_password_notification(req)
      end

    end
  end
end

