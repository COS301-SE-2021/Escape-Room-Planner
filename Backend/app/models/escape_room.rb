class EscapeRoom < ApplicationRecord
  belongs_to :user
  has_many :vertices
  validates :name, presence: true
end
