# frozen_string_literal: true

class DeleteUserRequest
  attr_accessor :username, :user_to_be_deleted

  def initialize(username, user_to_be_deleted)
    @username = username
    @user_to_be_deleted = user_to_be_deleted
  end
end
