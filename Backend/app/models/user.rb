class User < ApplicationRecord
  has_secure_password

  validates :id, uniqueness: true
  validates :username, uniqueness: true
  validates :email, uniqueness: true
  validates :password_digest, :isAdmin, presence: true
end