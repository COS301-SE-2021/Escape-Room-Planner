class UserServices
  def registerUser(request)
    raise 'RegisterUserRequest null' if request.nil?

    @user = User.new
    @user.username = request.username
    @user.password = request.password
    @user.email = request.email
    @user.isAdmin = request.isAdmin

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

    raise 'Username does not exist' if @user.nil?

    #check password is correct
    raise 'Incorrect Password' unless request.password.equal?(@user.password)

    #generate JWT token and attach to user

    @token = Authenticate.encode(@user.id)

    # store jwt token discuss with team
    # @cur_user.token = @token

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

  end

  def getUsers(request)

  end
end
