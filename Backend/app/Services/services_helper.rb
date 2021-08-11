def authorise(request)
  if request.headers['Authorization'].present?
    auth_token = request.headers['Authorization'].split(' ').last
    user_service = UserServices.new
    if user_service.authenticate_user(auth_token)
      true
    else
      false
    end
  else
    false
  end
end
