class AddFields < ActiveRecord::Migration[6.1]
  def change
    add_column :vertices, :z_index, :float
  end
end
