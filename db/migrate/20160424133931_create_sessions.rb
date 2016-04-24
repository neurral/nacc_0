class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_key
      t.datetime :expiration_datetime
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :sessions, [:session_key, :created_at], :unique => true
    add_index :sessions, [:session_key, :expiration_datetime], :unique => true

  end
end
