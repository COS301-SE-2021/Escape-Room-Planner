def authorise(request)
  if request.headers['Authorization1'].present? && request.headers['Authorization2'].present?
    auth_token = request.headers['Authorization1'].split(' ').last
    auth_username = request.headers['Authorization2'].split(' ').last
    user_service = UserServices.new
    if user_service.authenticate_user(auth_token, auth_username)
      true
    else
      false
    end
  else
    false
  end
end
