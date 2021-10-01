class CreateRoomRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :room_ratings do |t|
      t.integer :RoomID
      t.integer :Rating

      t.timestamps
    end
  end
end
