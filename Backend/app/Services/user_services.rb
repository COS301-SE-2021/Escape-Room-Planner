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
                  RegisterUserResponse.new(true, "User Creatwd Successfully")
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
                  LoginResponse.new(true, "User Creatwd Successfully")
                else
                  LoginResponse.new(false, "User Not Created")
                end
  end

  def updateAccount(request)

  end

  def resetPassword(request)

  end

  def getUserDetails(request)
    
  end
  
  def setAdmin(request)
    
  end
  
  def deleteUser(request)
    
  end
  
  def getUsers(request)

  end
end
