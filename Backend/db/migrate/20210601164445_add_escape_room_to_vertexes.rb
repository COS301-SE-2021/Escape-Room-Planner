class AddEscapeRoomToVertexes < ActiveRecord::Migration[6.1]
  def change
    add_reference :vertices, :escape_room, null: false, foreign_key: true, default: 1
  end
end
