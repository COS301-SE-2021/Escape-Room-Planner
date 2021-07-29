class User < ApplicationRecord
  has_secure_password

  validates :user_id, uniqueness: true
  validates :jwt_token, uniqueness: true
  validates :username, uniqueness: true
  validates :email, uniqueness: true
end