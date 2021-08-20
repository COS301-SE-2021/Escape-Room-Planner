class AddedVerifiedToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :verified, :boolean
  end
end
