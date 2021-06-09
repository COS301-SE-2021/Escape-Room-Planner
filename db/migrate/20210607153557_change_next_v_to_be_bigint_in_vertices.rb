class ChangeNextVToBeBigintInVertices < ActiveRecord::Migration[6.1]
  def change
    add_column :vertices, :new_column, :bigint
    add_column :escape_rooms, :new_column, :bigint
    add_column :escape_rooms, :new_column_2, :bigint

    remove_column :vertices, :nextV, :string
    remove_column :escape_rooms, :startVertex, :string
    remove_column :escape_rooms, :endVertex, :string

    rename_column :vertices, :new_column, :nextV
    rename_column :escape_rooms, :new_column, :startVertex
    rename_column :escape_rooms, :new_column_2, :endVertex
  end
end
