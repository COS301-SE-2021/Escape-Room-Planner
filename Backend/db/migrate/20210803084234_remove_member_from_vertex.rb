class RemoveMemberFromVertex < ActiveRecord::Migration[6.1]
  def change
    remove_column :vertices, :description, :string
    remove_column :vertices, :estimatedTime, :string
    remove_column :vertices, :clue, :string
  end
end
