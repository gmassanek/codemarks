class CreateLinkSaves < ActiveRecord::Migration
  def change
    create_table :link_saves do |t|
      t.integer :user_id
      t.integer :link_id
      t.timestamps
    end
  end
end
