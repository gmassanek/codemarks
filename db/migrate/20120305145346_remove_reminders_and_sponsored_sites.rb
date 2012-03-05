class RemoveRemindersAndSponsoredSites < ActiveRecord::Migration
  def up
    drop_table :reminders
    drop_table :sponsored_sites
  end

  def down
    create_table "reminders", :force => true do |t|
      t.integer  "link_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "completed",  :default => false
    end
    create_table "sponsored_sites", :force => true do |t|
      t.integer  "topic_id"
      t.string   "site"
      t.string   "url"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
