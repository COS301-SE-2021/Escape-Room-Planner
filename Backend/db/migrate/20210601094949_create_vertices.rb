class CreateVertices < ActiveRecord::Migration[6.1]
  def change
    create_table :vertices do |t|
      t.string :type
      t.string :idV
      t.string :name
      t.float :posx
      t.float :posy
      t.float :width
      t.float :height
      t.string :graphicid

      t.timestamps
    end
  end
end
