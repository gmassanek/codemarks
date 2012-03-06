class AddingIndexes < ActiveRecord::Migration
  def up
    add_index :link_records, :url
    add_index :users, :email
  end

  def down
    remove_index :link_records, :url
    remove_index :users, :email
  end
end
