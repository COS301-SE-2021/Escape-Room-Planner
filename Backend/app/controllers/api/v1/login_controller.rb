module Api
  module V1
    class LoginController < ApplicationController
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token

      def create
        username = params[:username]
        password = params[:password_digest]

        if username.nil? || password.nil?
          #return token
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given for login' }, status: :not_found
          return
        end

        serv = UserServices.new

        req = LoginRequest.new(username, password)
        res = serv.login(req)

        if res.success
          render json: { status: 'SUCCESS', message: res.message, auth_token: res.token}, status: :ok
        else
          render json: { status: 'FAILED', message: res.message}, status: 401
        end
      end
    end
  end
end
