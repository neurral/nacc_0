class AddDateStartToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :date_start, :date
  end
end
