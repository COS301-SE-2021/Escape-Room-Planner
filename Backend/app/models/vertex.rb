class Vertex < ApplicationRecord
  belongs_to :field, polymorphic: true
  belongs_to :escape_room

  has_and_belongs_to_many :vertices, join_table: 'vertex_edges', foreign_key: 'from_vertex_id',
                                     association_foreign_key: 'to_vertex_id'

  validates :id, uniqueness: true # forces id to be unique no matter what, dont really know if we need this
  validates :type, :name, :graphicid, presence: true # just presence for now
  validates :posx, :posy, numericality: true
  validates :width, :height, numericality: { greater_than: 0.0 } # forces to be a number and greater than 0
  # validates :estimatedTime
  # validates :description
  # validates :clue
  # validates :escape_room_id
end
