require './app/Services/login_request'
require './app/Services/register_user_request'
require './app/Services/register_user_request'

module Api
  module V1
    class UserController < ApplicationController
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token

      def index
        users = User.all
        render json: { status: 'SUCCESS', message: 'Users', data: users }, status: :ok
      end

      def create
        operation = params[:operation]
        email = params[:email]
        # is_admin = params[:is_admin]
        username = params[:username]
        password = params[:password]

        if password.nil? || username.nil?
          render json: { status: 'FAILED', message: 'Ensure correct parameters are given for register' }, status: :not_found
          return
        end

        serv = UserServices.new

        case operation
        when 'Register'
          if User.where('username = ?', username).count >= 1
            render json: { status: 'Fail', message: 'User already exists', data: "Created: false" }, status: :bad_request
            return
          end

          req = RegisterUserRequest.new(username, password, email, true)
          res = serv.registerUser(req)

        when 'Login'
          if username.nil? || password.nil?
            # return token
            render json: { status: 'FAILED', message: 'Ensure correct parameters are given for login' }, status: :not_found
            return
          end
          req = LoginRequest.new(username, password)
          res = serv.login(req)

          if res.success
            render json: { status: 'SUCCESS', message: res.message, auth_token: res.token }, status: :ok
            return
          else
            render json: { status: 'FAILED', message: res.message }, status: 401
            return
          end
        else
          render json: { status: 'FAILED', message: 'Ensure type is correct with correct parameters' }, status: :not_found
          return
        end




        # when 'Verify'

        # when 'login'
        #   if username.nil? || password.nil?
        #     #return token
        #     render json: { status: 'FAILED', message: 'Ensure correct parameters are given for login' }, status: :not_found
        #     return
        #   end
        #
        #   req = LoginRequest.new(username, password)
        #   res = serv.login(req)
        #
        #   if res.success
        #     render json: { status: 'SUCCESS', message: res.message, auth_token: res.token}, status: :ok
        #   else
        #     render json: { status: 'FAILED', message: res.message}, status: 401
        #   end
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

        render json: { status: 'SUCCESS', message: 'User:', data: "Created: #{res.success}" }, status: :ok
      rescue StandardError
        render json: { status: 'FAILED', message: 'Unspecified error' }, status: :not_found

      end
    end
  end
end