class CreateEscapeRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :escape_rooms do |t|
      t.string :startVertex
      t.string :endVertex

      t.timestamps
    end
  end
end
