class ChangeUserToHoldToken < ActiveRecord::Migration
  def change
  	add_column :users, :token, :string
  	add_column :users, :token_expiry, :date
  	add_column :users, :user_type, :integer, default: 0
  	#refers to Access Level privileges later: Guest 0, Employee 1, Exec 2

  	add_index :users, :token
  end
end
