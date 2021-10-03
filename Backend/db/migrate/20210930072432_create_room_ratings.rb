class CreateRoomRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :room_ratings do |t|
      t.integer :rating
      t.timestamps
    end
    add_reference :room_ratings, :user, { null: false, foreign_key: true }
    add_reference :room_ratings, :public_room, { null: false, foreign_key: true }
  end
end
