class CreatePublicRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :public_rooms do |t|
      t.bigint :best_time
      t.timestamps
    end
    add_reference :public_rooms, :escape_room, { null: false, foreign_key: true }
  end
end
