class DropComments < ActiveRecord::Migration
  def up
    drop_table :comments
  end

  def down
    create_table "comments" do |t|
      t.integer  "codemark_id"
      t.integer  "author_id"
      t.text     "text"

      t.timestamps
    end
  end
end
