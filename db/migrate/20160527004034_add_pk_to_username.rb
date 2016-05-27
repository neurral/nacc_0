class AddPkToUsername < ActiveRecord::Migration
  def change
  	execute "ALTER TABLE usernames ADD PRIMARY KEY (year);"
  end
end
