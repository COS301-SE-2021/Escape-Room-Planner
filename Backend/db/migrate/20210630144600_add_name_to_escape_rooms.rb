class AddNameToEscapeRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :escape_rooms, :name, :string
  end
end
