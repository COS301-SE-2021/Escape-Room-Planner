class Clue < Vertex
  # validates :nextV
  # validates :estimatedTime
  # validates :description
  validates :clue, presence: true # just needs to have a clue text of some sort
  # validates :escape_room_id
end
