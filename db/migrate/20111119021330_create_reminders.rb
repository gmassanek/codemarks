class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :link_id
      t.integer :user_id

      t.timestamps
    end
  end
end
