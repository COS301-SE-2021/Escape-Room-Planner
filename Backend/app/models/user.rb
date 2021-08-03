class User < ApplicationRecord
  has_secure_password

  validates :id, :username, :email, uniqueness: true
  validates :password_digest, :is_admin, presence: true
end