class DropSponsoredSites < ActiveRecord::Migration
  def up
    drop_table :sponsored_sites
  end

  def down
    create_table "sponsored_sites", :force => true do |t|
      t.integer  "topic_id"
      t.string   "site"
      t.string   "url"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
