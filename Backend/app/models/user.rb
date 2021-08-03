class User < ApplicationRecord
  has_secure_password

  validates :id, :username, :email, uniqueness: true
  validates :is_admin, inclusion: { in: [ true, false ] }
  validates :password_digest, presence: true
end