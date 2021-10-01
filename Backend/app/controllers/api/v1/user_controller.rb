require './app/Services/services_helper'
require './app/Services/UserSubsystem/Request/login_request'
require './app/Services/UserSubsystem/Response/login_response'
require './app/Services/UserSubsystem/Request/register_user_request'
require './app/Services/UserSubsystem/Response/register_user_response'
require './app/Services/UserSubsystem/Request/reset_password_request'
require './app/Services/UserSubsystem/Response/reset_password_response'
require './app/Services/UserSubsystem/Request/verify_account_request'
require './app/Services/UserSubsystem/Response/verify_account_response'
require './app/Services/UserSubsystem/user_services'

module Api
  module V1
    class UserController < ApplicationController
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token

      def index
        render json: { status: 'SUCCESS', message: 'This page is used for uptime only' }, status: :ok
      end

      def create
        operation = params[:operation]
        email = params[:email]
        # is_admin = params[:is_admin]
        username = params[:username]
        password = params[:password]
        new_password = params[:new_password]

        serv = UserServices.new

        case operation
        when 'Register'
          if password.empty? || username.empty? || email.empty?
            render json: { status: 'FAILED', message: 'Ensure correct parameters are given for register' }, status: :not_found
            return
          end

          if User.find_by_username(username)
            render json: { status: 'FAILED', message: 'Username is taken', data: "Created: false" }, status: :conflict
            return
          end

          if User.find_by_email(email)
            render json: { status: 'FAILED', message: 'Email is taken', data: "Created: false" }, status: :conflict
            return
          end

          if new_password != password
            render json: { status: 'FAILED', message: 'Password does not match.' }, status: 401
            return
          end

          req = RegisterUserRequest.new(username, password, email)
          res = serv.register_user(req)

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

        when 'reset_password'
          if params[:reset_token].nil?
            render json: { status: 'FAILED', message: 'No reset_token received' }, status: 400
            return
          else
            req = ResetPasswordRequest.new(params[:reset_token], new_password)
            resp = serv.reset_password(req)
            render json: { status: 'Response received', message: 'Data:', data: resp }, status: :ok
            return
          end

        when 'Verify'
          if authorise(request)
            render json: { status: 'SUCCESS' }, status: :ok
            return
          else
            render json: { status: 'FAILED' }, status: :unauthorized
            return
          end

        when 'verify_account'
          if params[:verify_token].nil?
            render json: { status: 'FAILED', message: 'No verify_token received' }, status: 400
            return
          else
            req = VerifyAccountRequest.new(params[:verify_token])
            resp = serv.verify_account(req)
            render json: { status: 'Response received', message: 'Data:', data: resp }, status: :ok
            return
          end

        else
          render json: { status: 'FAILED', message: 'Ensure type is correct with correct parameters' }, status: :not_found
          return
        end

        end
      end
    end
  end
