class AddColumncToTableName < ActiveRecord::Migration[6.1]
  def change
    add_column :vertices, :nextV, :string
  end
end
