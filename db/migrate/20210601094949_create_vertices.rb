class CreateVertices < ActiveRecord::Migration[6.1]
  def change
    create_table :vertices do |t|
      t.String :type
      t.String :id
      t.String :name
      t.float :posx
      t.float :posy
      t.float :width
      t.float :height
      t.string :graphicid

      t.timestamps
    end
  end
end
