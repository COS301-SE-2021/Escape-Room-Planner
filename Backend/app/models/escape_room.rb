# frozen_string_literal: true

class EscapeRoom < ApplicationRecord
  belongs_to :user
  has_one :public_room, dependent: :destroy
  has_many :vertices, dependent: :destroy
  has_many :room_images, dependent: :destroy
  validates :name, presence: true
end
