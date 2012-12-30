class RemoveOldTables < ActiveRecord::Migration
  def up
    drop_table "link_saves"
    drop_table "link_topics"
    drop_table "reminders"
    drop_table "sponsored_sites"
    drop_table "user_topics"
  end

  def down
    create_table "link_saves" do |t|
      t.integer  "user_id"
      t.integer  "link_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "link_topics" do |t|
      t.integer  "link_id"
      t.integer  "topic_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id"
    end

    create_table "reminders" do |t|
      t.integer  "link_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "completed",  :default => false
    end

    create_table "sponsored_sites" do |t|
      t.integer  "topic_id"
      t.string   "site"
      t.string   "url"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "user_topics" do |t|
      t.integer  "user_id"
      t.integer  "topic_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
