class AddForeignkeyToTableVertices < ActiveRecord::Migration[6.1]
  def change
    add_column :vertices, :escape_rooms_id, :string
  end
end
