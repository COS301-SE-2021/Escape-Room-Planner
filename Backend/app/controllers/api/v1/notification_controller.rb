require './app/Services/services_helper'
require './app/Services/NotificationSubsystem/notification_services'
require './app/Services/NotificationSubsystem/Request/send_email_notification_request'
require './app/Services/NotificationSubsystem/Response/send_email_notification_response'

module Api
  module V1
    class NotificationController < ApplicationController
      protect_from_forgery with: :null_session
      # skip_before_action :verify_authenticity_token
      rescue_from JWT::ExpiredSignature, with: :forbidden
      rescue_from JWT::DecodeError, with: :forbidden

      def create
        # if authorise(request)
          operation = params[:operation]

          if operation == "Reset Password"
            if params[:email].empty?
              render json: { status: 'FAILED', message: 'No email received' }, status: 400
              return
            end

            req = SendEmailNotificationRequest.new('resetPassword', params[:email])
            serv = NotificationServices.new
            resp = serv.send_email_notification(req)
            if(resp.success)
              render json: { status: 'Response received', message: resp.message}, status: :ok
              return
            else
              render json: { status: 'FAILED', message: resp.message}, status: :conflict
              return
            end
          end

          if operation == "Verify Account"
            if params[:email].nil?
              render json: { status: 'FAILED', message: 'No email received' }, status: 400
              return

            else
              resp = verify_account(params[:email])
              render json: { status: 'Response received',  message: resp.message }, status: :ok
            end

          end

          if operation == "check_expiration"
            if params[:encoded_token].nil?
              render json: { status: 'FAILED', message: 'No token received' }, status: 400
              return

            else
              JsonWebToken.decode(params[:encoded_token])
              render json: { status: 'Response received'}, status: :ok
            end
          end
      end

      def reset_password(email)
        # req = ResetPasswordNotificationRequest.new(email)
        # serv = UserServices.new
        # serv.reset_password_notification(req)

        req = SendEmailNotificationRequest.new('resetPassword', email)
        serv = NotificationServices.new
        serv.send_email_notification(req)
      end


      def verify_account(email)
        req = SendEmailNotificationRequest.new('verifyAccount', email)
        serv = NotificationServices.new
        serv.send_email_notification(req)
      end

    end
  end
end

