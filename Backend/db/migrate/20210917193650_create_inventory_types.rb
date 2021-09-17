class CreateInventoryTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :inventory_types do |t|
      t.string :image_type, default: 'container'
      t.bigint :blob_id
      t.timestamps
    end
  end
end
