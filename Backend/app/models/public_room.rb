class PublicRoom < ApplicationRecord
  belongs_to :escape_room
  has_many :room_ratings, dependent: :destroy
  validates :escape_rooms_id, presence: true
end
