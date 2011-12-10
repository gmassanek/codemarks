class DropReminders < ActiveRecord::Migration
  def up
    drop_table :reminders
  end

  def down
    create_table "reminders", :force => true do |t|
      t.integer  "link_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "completed",  :default => false
    end
  end
end
