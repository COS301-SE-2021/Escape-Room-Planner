class Vertex < ApplicationRecord
  belongs_to :escape_room
  validates :id, uniqueness: true # forces id to be unique no matter what, dont really know if we need this
  validates :id, :name, :graphicid, presence: true # just presence for now
  validates :posx, :posy, :width, :height, numericality: true # forces floats to these?
  # validates :nextV
  # validates :estimatedTime
  # validates :description
  # validates :clue
  # validates :escape_room_id
end
