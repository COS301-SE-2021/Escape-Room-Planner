class User < ApplicationRecord
  validates :id, :username, :email, uniqueness: true
end