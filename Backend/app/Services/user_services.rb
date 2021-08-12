# frozen_string_literal: true

class UserServices
  def register_user(request)
    return RegisterUserResponse.new(false, 'Null request') if request.nil?

    begin
      @user = User.new
      @user.username = request.username
      @user.email = request.email
      @user.is_admin = false

      # salt and hash password and store it

      @user.password = request.password

      @response = if @user.save!
                    RegisterUserResponse.new(true, 'User Created Successfully')
                  else
                    RegisterUserResponse.new(false, 'User Not Created')
                  end
    rescue StandardError => e
      RegisterUserResponse.new(false, e)
    end
  end

  def login(request)
    return LoginResponse.new(false, 'Null request', nil) if request.nil?

    # raise 'LoginRequest null' if request.nil?

    # find user in database and retrieve it if it exists
    @user = User.find_by(username: request.username)

    # check username exists
    return LoginResponse.new(false, 'Username does not exist', nil) if @user.nil?
    # raise 'Username does not exist' if @user.nil?

    # check password is correct
    return LoginResponse.new(false, 'Password is incorrect', nil) unless @user.authenticate(request.password)

    # raise 'Incorrect Password' unless @user.authenticate(request.password)

    # generate JWT token

    @token = JsonWebToken.encode(id: @user.id)

    # store jwt token discuss with team
    @user.jwt_token = @token

    @response = if @user.save
                  LoginResponse.new(true, 'Login Successful', @token)
                else
                  LoginResponse.new(false, 'Login Failed', nil)
                end
  end

  def reset_password(request)
    return ResetPasswordResponse.new(false, 'Reset Password request null') if request.nil?

    @user = User.find_by_username(request.username)
    return ResetPasswordResponse.new(false, 'Username does not exist') if @user.nil?

    @user.update(password: request.new_password)

    @response = if @user.save
                  ResetPasswordResponse.new(true, 'Password reset Successfully')
                else
                  ResetPasswordResponse.new(false, 'Password Not Reset')
                end
  end

  def get_user_details(request)
    raise 'GetUserDetailsRequest null' if request.nil?

    @user = User.new
    @user.username = request.username
    @user.password = request.password
    @user.email = request.email

    @response = if @user.save
                  GetUserDetailsResponse.new(true, 'Successful')
                else
                  GetUserDetailsResponse.new(false, 'Failed')
                end
  end

  def delete_user(request)
    raise 'SetAdminRequest null' if request.nil?

    @user = User.find_by_username(request.username)

    raise 'User does not exist' if @user.nil?

    # A non-admin user cannot delete another user
    raise 'Current user is not an admin' unless @user.is_admin

    @user_to_be_deleted = User.find_by_username(request.user_to_be_deleted)

    # check user to be deleted exists
    raise 'User to be deleted does not exist' if @user_to_be_deleted.nil?

    User.destroy(@user_to_be_deleted.id)

    @response = if User.find_by_username(request.username).nil?
                  DeleteUserResponse.new(true, 'Successfully deleted user')
                else
                  DeleteUserResponse.new(false, 'Failed to delete user')
                end
  end

  # def setAdmin(request)
  #   raise 'SetAdminRequest null' if request.nil?
  #
  #   @user = User.find_by_username(request.username)
  #
  #   raise 'User does not exist' if @user.nil?
  #
  #   @user.is_admin = true
  #
  #   @response = if @user.save
  #                 SetAdminResponse.new(true, 'Successful')
  #               else
  #                 SetAdminResponse.new(false, 'Failed')
  #               end
  # end

  def get_users(request); end

  def update_account(request); end

  def verify_account(request); end

  def authenticate_user(encoded_token)
    decoded_token = JsonWebToken.decode(encoded_token)
    @response = if User.find_by_id(decoded_token['id'])
                  true
                else
                  false
                end
  rescue JWT::ExpiredSignature
    false
  rescue StandardError
    false
  end
end
