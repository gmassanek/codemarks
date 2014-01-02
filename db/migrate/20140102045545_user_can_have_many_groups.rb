class UserCanHaveManyGroups < ActiveRecord::Migration
  def up
    remove_column :users, :group_id
    
    create_table :groups_users do |t|
      t.integer :group_id
      t.integer :user_id
    end
  end

  def down
    add_column :users, :group_id, :integer
    
    drop_table :groups_users
  end
end
