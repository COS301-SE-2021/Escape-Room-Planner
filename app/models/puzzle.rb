class Puzzle < Vertex
  # validates :nextV
  validates :estimatedTime, :description, presence: true # just checks presence, since can be anything for user.
  # validates :clue
  # validates :escape_room_id
end
