class EscapeRoom < ApplicationRecord
  has_many :vertices, dependent: :delete_all
  validates :name, presence: true
end
