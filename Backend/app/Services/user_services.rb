class UserServices
  def registerUser(request)
    raise 'RegisterUserRequest null' if request.nil?
    @user = User.new
    @user.username = request.username
    @user.password = request.password
    @user.email = request.email
    @user.name = request.name
    @user.isAdmin = request.isAdmin

    @response = if @user.save
                  RegisterUserResponse.new(true, "User Created Successfully")
                else
                  RegisterUserResponse.new(false, "User Not Created")
                end
  end

  def verifyAccount(request)

  end

  def login(request)
    raise 'LoginRequest null' if request.nil?
    @user = User.new
    @user.username = request.username
    @user.password = request.password

    @response = if @user.save
                  LoginResponse.new(true, "Login Successfully")
                else
                  LoginResponse.new(false, "Login Failed")
                end
  end

  def updateAccount(request)

  end

  def resetPassword(request)
    raise 'ResetPasswordRequest null' if request.nil?
    @user = User.new
    @user.username = request.username
    @user.password = request.password
    @user.newPassword = request.newPassword

    @response = if @user.save
                  ResetPasswordResponse.new(true, "Password reset Successfully")
                else
                  ResetPasswordResponse.new(false, "Password Not Reset")
                end
  end

  def getUserDetails(request)
    raise 'GetUserDetailsRequest null' if request.nil?
    @user = User.new
    @user.username = request.username
    @user.password = request.password
    @user.email = request.email

    @response = if @user.save
                  GetUserDetailsResponse.new(true, "Successful")
                else
                  GetUserDetailsResponse.new(false, "Failed")
                end
  end
  
  def setAdmin(request)
    raise 'SetAdminRequest null' if request.nil?
    @user = User.new
    @user.username = request.username
    @user.password = request.password
    @user.email = request.email
    @user.name = request.name
    @user.isAdmin = request.isAdmin

    @response = if @user.save
                  SetAdminResponse.new(true, "Successful")
                else
                  SetAdminResponse.new(false, "Failed")
                end
  end
  
  def deleteUser(request)
    
  end
  
  def getUsers(request)

  end
end
