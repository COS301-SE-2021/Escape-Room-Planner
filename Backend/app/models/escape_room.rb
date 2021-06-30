class EscapeRoom < ApplicationRecord
  has_many :vertices
  validates :name, presence: true
end
