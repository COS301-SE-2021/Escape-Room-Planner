require './app/Services/login_request'
require './app/Services/register_user_request'
require './app/Services/register_user_request'

module Api
  module V1
    class UserController < ApplicationController
      protect_from_forgery with: :null_session
      def index
        users = User.all
        render json: {status: 'SUCCESS', message: 'Users', data: users}, status: :ok
      end

      def create
        type = params[:type]
        email = params[:name]
        name = params[:name]
        isAdmin = params[:isAdmin]
        username = params[:username]
        password = params[:password]
        newPassword = params[:newPassword]

        if name.nil? || password.nil? || isAdmin.nil? || email.nil? || username.nil?
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
          return
        end

        serv = UserServices.new

        case type
        when 'Register'
          if email.nil? || isAdmin.nil? || name.nil? || username.nil?|| email.nil? || password.nil?
            render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
            return
          end

          req = RegisterUserRequest.new(username, password, email, name, isAdmin)
          res = serv.registerUser(req)

        # when 'Verify'

        when 'Login'
          if username.nil? || password.nil?
            render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
            return
          end

          req = LoginRequest.new(username, password)
          res = serv.login(req)

        when 'UpdateAccount'

        when 'resetPassword'
          if username.nil? || password.nil? || newPassword.nil?
            render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
            return
          end

          req = ResetPasswordRequest.new(username, password, newPassword)
          res = serv.resetPassword(req)

        when 'GetUserDetails'
          if username.nil? || password.nil? || email.nil?
            render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
            return
          end

          req = GetUserDetailsRequest.new(username, password, email)
          res = serv.getUserDetails(req)

        when 'SetAdmin'
          if username.nil? || password.nil? || email.nil? || name.nil? || isAdmin.nil?
            render json: { status: 'FAILED', message: 'Ensure correct parameters are given' }, status: :not_found
            return
          end

          req = SetAdminRequest.new(username, password, email, name, isAdmin)
          res = serv.setAdmin(req)

        # when 'DeleteUser'

        # when 'GetUsers'

        else
          render json: {status: 'FAILED', message: 'Ensure type is correct with correct parameters'}, status: :not_found
          return
        end

        render json: {status: 'SUCCESS', message: 'User:', data: "Created: #{res.success}"}, status: :ok
      rescue StandardError
        render json: {status: 'FAILED', message: 'Unspecified error'}, status: :not_found

      end
    end
  end
end
