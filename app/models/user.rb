class User < ApplicationRecord
  validates :id, :username, :email, uniqueness: true
  validates :password, :name, :isAdmin, presence: true
end