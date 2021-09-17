class CreateInventoryTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :inventory_types do |t|
      t.string :image_type, default: 'container'
      t.timestamps
    end

    add_reference :inventory_types, :active_storage_blobs, { null: false, foreign_key: true }
  end
end
