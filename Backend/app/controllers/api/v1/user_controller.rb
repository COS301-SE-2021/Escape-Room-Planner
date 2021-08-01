require './app/Services/login_request'
require './app/Services/register_user_request'
require './app/Services/register_user_request'
require 'bcrypt'

module Api
  module V1
    class UserController < ApplicationController
      include BCrypt
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token

      def index
        users = User.all
        render json: {status: 'SUCCESS', message: 'Users', data: users}, status: :ok
      end

      def create
        email = params[:email]
        username = params[:username]
        password_digest = params[:password_digest]

        if User.where('user = ?', username).count >= 1
          render json: {status: 'Fail', message: 'User already exists', data: "Created: false"}, status: :bad_request
          return
        end

        if password_digest.nil? || email.nil? || username.nil?
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
          return
        end

        serv = UserServices.new
        req = RegisterUserRequest.new(username, password_digest, email, true )
        res = serv.registerUser(req)

        # when 'Verify'

        # when 'Login'
        #   if username.nil? || password.nil?
        #     render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
        #     return
        #   end
        #
        #   req = LoginRequest.new(username, password)
        #   res = serv.login(req)
        #
        # when 'UpdateAccount'
        #
        # when 'resetPassword'
        #   if username.nil? || password.nil? || newPassword.nil?
        #     render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
        #     return
        #   end
        #
        #   req = ResetPasswordRequest.new(username, password, newPassword)
        #   res = serv.resetPassword(req)
        #
        # when 'GetUserDetails'
        #   if username.nil? || password.nil? || email.nil?
        #     render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
        #     return
        #   end
        #
        #   req = GetUserDetailsRequest.new(username, password, email)
        #   res = serv.getUserDetails(req)
        #
        # when 'SetAdmin'
        #   if username.nil? || password.nil? || email.nil? || name.nil? || isAdmin.nil?
        #     render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
        #     return
        #   end
        #
        #   req = SetAdminRequest.new(username, password, email, name, isAdmin)
        #   res = serv.setAdmin(req)

        # when 'DeleteUser'

        # when 'GetUsers'

        # else
        #   render json: {status: 'FAILED', message: 'Ensure type is correct with correct parameters'}, status: :not_found
        #   return
        # end

        render json: {status: 'SUCCESS', message: 'User:', data: "Created: #{res.success}"}, status: :ok
      rescue StandardError
        render json: {status: 'FAILED', message: 'Unspecified error'}, status: :not_found

      end
    end
  end
end
