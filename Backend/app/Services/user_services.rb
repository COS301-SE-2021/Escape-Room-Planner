class UserServices
  def registerUser(request)
    raise 'RegisterUserRequest null' if request.nil?

    @user = User.new
    # @user.id = 9
    @user.user_id = 48
    @user.username = request.username
    @user.email = request.email
    @user.password_digest = request.password_digest
    @user.isAdmin = request.isAdmin
    @user.jwt_token = "dsfseeaaaaaea"
    @user.type = "Register"

    #hash password and store it

    # @user.password_digest = request.password_digest

    @response = if @user.save
                  RegisterUserResponse.new(true, 'User Created Successfully')
                else
                  RegisterUserResponse.new(false, 'User Not Created')
                end
  end

  def verifyAccount(request)

  end

  def login(request)
    raise 'LoginRequest null' if request.nil?

    #find user in database and retrieve it if it exists
    @user = User.find_by(username: request.username)

    raise 'User does not exist' if @user.nil?

    #check password is correct
    raise 'Incorrect Password' unless @user.authenticate(@user.password)

    #generate JWT token and attach to user

    @token = Authenticate.encode(@user.id)

    # store jwt token discuss with team
    @user.jwt_token = @token

    @response = if @user.save
                  LoginResponse.new(true, 'Login Successful')
                else
                  LoginResponse.new(false, 'Login Failed')
                end
  end

  def updateAccount(request)


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

  def setAdmin(request)
    raise 'SetAdminRequest null' if request.nil?

    @user = User.find_by_username(request.username)

    raise 'User does not exist' if @user.nil?

    @user.isAdmin = true

    @response = if @user.save
                  SetAdminResponse.new(true, 'Successful')
                else
                  SetAdminResponse.new(false, 'Failed')
                end
  end

  def deleteUser(request)
    raise 'SetAdminRequest null' if request.nil?

    @user = User.find_by_username(request.username)

    raise 'User does not exist' if @user.nil?

    # A non-admin user cannpt delete another user
    raise 'Current user is not an admin' unless @user.isAdmin

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

  def getUsers(request)

  end
end
