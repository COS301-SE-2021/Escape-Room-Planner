# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :escape_rooms

  validates :id, :username, :email, uniqueness: true
  validates :is_admin, inclusion: { in: [true, false] }
  validates :password_digest, presence: true
end
