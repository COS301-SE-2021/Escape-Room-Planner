class UserServices
  def registerUser(request)
    return RegisterUserResponse.new(false, 'Null request') if request.nil?

    @user = User.new
    @user.username = request.username
    @user.email = request.email
    @user.is_admin = request.is_admin

    #salt and hash password and store it

    @user.password = request.password


    @response = if @user.save
                  RegisterUserResponse.new(true, 'User Created Successfully')
                else
                  RegisterUserResponse.new(false, 'User Not Created')
                end
  end

  def login(request)
    raise 'LoginRequest null' if request.nil?

    #find user in database and retrieve it if it exists
    @user = User.find_by(username: request.username)

    raise 'Username does not exist' if @user.nil?

    #check password is correct
    raise 'Incorrect Password' unless @user.authenticate(@user.password)

    #generate JWT token

    @token = JsonWebToken.encode(@user.id)

    # store jwt token discuss with team
    @user.jwt_token = @token

    @response = if @user.save
                  LoginResponse.new(true, 'Login Successful', @token)
                else
                  LoginResponse.new(false, 'Login Failed', nil)
                end
  end

  def resetPassword(request)
    raise 'ResetPasswordRequest null' if request.nil?

    @user = User.find_by_username(request.username)
    raise 'Username does not exist' if @user.nil?

    @user.password = request.newPassword

    @response = if @user.save
                  ResetPasswordResponse.new(true, 'Password reset Successfully')
                else
                  ResetPasswordResponse.new(false, 'Password Not Reset')
                end
  end

  def getUserDetails(request)
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

  def deleteUser(request)
    raise 'SetAdminRequest null' if request.nil?

    @user = User.find_by_username(request.username)

    raise 'User does not exist' if @user.nil?

    # A non-admin user cannpt delete another user
    raise 'Current user is not an admin' unless @user.is_admin

    @user_to_be_deleted = User.find_by_username(request.user_to_be_deleted)

    #check user to be deleted exists
    raise 'User to be deleted does not exist' if @user_to_be_deleted.nil?

    User.destroy(@user_to_be_deleted.id)

    @response = if User.find_by_username(request.username).nil?
                  DeleteUserResponse.new(true, 'Successfully deleted user')
                else
                  DeleteUserResponse.new(false , 'Failed to delete user')
                end

  end

  def setAdmin(request)
    raise 'SetAdminRequest null' if request.nil?

    @user = User.find_by_username(request.username)

    raise 'User does not exist' if @user.nil?

    @user.is_admin = true

    @response = if @user.save
                  SetAdminResponse.new(true, 'Successful')
                else
                  SetAdminResponse.new(false, 'Failed')
                end
  end

  def getUsers(request)

  end

  def updateAccount(request)


  end

  def verifyAccount(request)

  end

  def authenticateUser(headers)

    if headers['Authorization'].present?
      #get token from header
      @encoded_token = headers['Authorization'].split('').last

      # decode token
      @decoded_token = JsonWebToken.decode(@encoded_token)

      #check token exists
      @response = if User.find_by(jwt_token: @decoded_token)
                    true
                  else
                    false
                  end
    else
      raise 'Missing Token'
    end
  end
end
