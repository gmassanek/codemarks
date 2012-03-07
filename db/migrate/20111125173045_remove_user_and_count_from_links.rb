class RemoveUserAndCountFromLinks < ActiveRecord::Migration
  def up
    remove_column :links, :user_id
  end

  def down
    add_column :links, :user_id, :integer
  end
end
