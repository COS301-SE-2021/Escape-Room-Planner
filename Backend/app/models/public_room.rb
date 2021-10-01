class PublicRoom < ApplicationRecord
  validates :RoomID, presence: true
end
