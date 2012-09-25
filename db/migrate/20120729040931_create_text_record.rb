class CreateTextRecord < ActiveRecord::Migration
  def up
    create_table :text_records do |t|
      t.string   "text"
      t.integer  "author_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    drop_table :text_records
  end
end
