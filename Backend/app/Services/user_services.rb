class UserServices
  def registerUser(request)
    return RegisterUserResponse(false,"The register user request is null") if request == nil
    # do i need to check that a user with that username doesn't exist


    @newUser = User.new
    @newUser.username = request.username
    @newUser.email = request.email
    # has_secure_password encrypts the password when passing it to the database. Need to double check with db migrate
    @newUser.password_digest = request.password_digest
    @newUser.name = request.name
    @newUser.isAdmin = request.isAdmin

    @response = if @newUser.save
                  RegisterUserResponse(true, "New User Succesfully Registered")
                else
                  #How do we identify later what caused the database error
                  RegisterUserResponse(false, "New User Failed to be registered")
                end
  end

  def verifyAccount(request)

  end

  def login(request)

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
