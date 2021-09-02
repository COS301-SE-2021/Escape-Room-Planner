class AddEstimatedtimeToVertices < ActiveRecord::Migration[6.1]
  def change
    add_column :vertices, :estimatedTime, :bigint
    add_column :vertices, :description, :string
    add_column :vertices, :clue, :string
  end
end
