class DeleteNextVColumnFromVertices < ActiveRecord::Migration[6.1]
  #this deletes nextV column, since it will not be needed anymore.
  # Use join table associations
  # If confused, contact Egor, I will explain
  def change
    # type provided in case we want to revert the change
    remove_column :vertices, :nextV, :bigint
  end
end
