class AddDetailsToUsers < ActiveRecord::Migration
def change
    change_table :users do |t|
      t.column :status, :integer, default: 0
      t.string :email
      t.date   :birthday
      t.string :cellphone_number
 	  t.string :telephone_number
 	  t.string :address
 	  t.binary :photo

    end
  end
end
