class User < ApplicationRecord
  has_secure_password

  validates :id, :username, :email, uniqueness: true
  validates :password_digest, :isAdmin, presence: true
end