class RemoveLinkSaves < ActiveRecord::Migration
  def up
    drop_table :link_saves
  end

  def down
    create_table "link_saves", :force => true do |t|
      t.integer  "user_id"
      t.integer  "link_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
