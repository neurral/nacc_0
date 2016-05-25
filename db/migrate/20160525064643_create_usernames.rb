class CreateUsernames < ActiveRecord::Migration
  def change
    create_table :usernames, id: false do |t|
      t.integer :year, null: false
      t.integer :seq, null: false

      t.timestamps null: false
    end

    add_index :usernames, [:year,:seq]
  end
end
