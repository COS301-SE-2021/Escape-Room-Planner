class RemoveFieldNameFromTableName < ActiveRecord::Migration[6.1]
  def change
    remove_column :vertices, :idV, :string
  end
end
