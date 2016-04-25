class CreateUserIdentities < ActiveRecord::Migration
  def change
    create_table :user_identities do |t|
      t.references :user, index: true, foreign_key: true
      t.string :username
      t.string :password_hash
      t.index :username, unique: true
      t.timestamps null: false
    end
  end
end
