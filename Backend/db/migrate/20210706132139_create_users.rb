class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :user_id, null: false
      t.string :username, null: false
      t.string :email, null: false
      t.column :password_digest, :string
      t.boolean :isAdmin
      t.string :jwt_token

      t.timestamps
    end
  end
end
