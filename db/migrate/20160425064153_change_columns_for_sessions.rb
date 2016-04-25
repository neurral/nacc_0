class ChangeColumnsForSessions < ActiveRecord::Migration
	def change
		change_table :sessions do |t|
			t.boolean :active, default: false
			t.rename :expiration_datetime, :expiry

			#Add composite index
			add_index :sessions, [:user_id, :session_key, :expiry]
			add_index :sessions, [:user_id, :session_key, :active]
		end
	end
end
