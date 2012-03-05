class DropLinkTopics < ActiveRecord::Migration
  def up
    drop_table :link_topics
  end

  def down
    create_table "link_topics", :force => true do |t|
      t.integer  "link_record_id"
      t.integer  "topic_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "user_id"
    end
  end
end
