class PublicRoom < ApplicationRecord
  belongs_to :escape_room
  has_many :room_ratings, dependent: :destroy
  validates :escape_room_id, presence: true
  validates :escape_room_id, uniqueness: true
  attribute :best_time, :integer, default: 0
end
