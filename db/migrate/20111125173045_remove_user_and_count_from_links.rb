class RemoveUserAndCountFromLinks < ActiveRecord::Migration
  def up
    remove_column :links, :user_id
    remove_column :links, :save_count
  end

  def down
    add_column :links, :user_id, :integer
    add_column :links, :save_count, :integer
  end
end
