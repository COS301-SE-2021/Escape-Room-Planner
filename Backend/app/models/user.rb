class User < ApplicationRecord
  has_secure_password

  validates :id, :username, :email, uniqueness: true
  validates :password, :name, :isAdmin, :type, presence: true
end