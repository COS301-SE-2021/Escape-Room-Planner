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

        end
      end

    end
  end
end

