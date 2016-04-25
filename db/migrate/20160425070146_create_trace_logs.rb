class CreateTraceLogs < ActiveRecord::Migration
  def change
    create_table :trace_logs do |t|
      t.datetime :log_time
      t.integer :user_id
      t.integer :rrn
      t.text :description

      t.index :rrn
      t.index :log_time
      t.index :user_id
    end
	
	execute 'alter table trace_logs alter column log_time set default now()'
  end
end
