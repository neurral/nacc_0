class ChangUsersTokenExpiryType < ActiveRecord::Migration
  def change
	  change_column :users, :token_expiry, :datetime
  
  end
end
