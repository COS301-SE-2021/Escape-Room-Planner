module Api
  module V1
    class NotificationController < ApplicationController
      protect_from_forgery with: :null_session


    end
  end
end

