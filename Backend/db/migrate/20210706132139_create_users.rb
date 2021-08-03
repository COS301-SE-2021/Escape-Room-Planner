class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email
      t.string :password_digest, null: false
      t.boolean :is_admin
      t.string :jwt_token
      t.string :type
      t.timestamps
    end
  end
end
