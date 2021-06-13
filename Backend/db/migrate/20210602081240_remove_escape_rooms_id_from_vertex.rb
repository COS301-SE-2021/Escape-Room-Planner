class RemoveEscapeRoomsIdFromVertex < ActiveRecord::Migration[6.1]
  def change
    remove_column :vertices, :escape_rooms_id, :string
  end
end
