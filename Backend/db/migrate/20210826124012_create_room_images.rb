class CreateRoomImages < ActiveRecord::Migration[6.1]
  def change
    create_table :room_images do |t|
      t.float :pos_x
      t.float :pos_y
      t.float :width
      t.float :height
      t.bigint :blob_id
    end

    add_reference :room_images, :escape_room, { null:false, foreign_key: true }
  end
end
