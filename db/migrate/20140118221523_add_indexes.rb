class AddIndexes < ActiveRecord::Migration
  def up
    add_index :authentications, :user_id
    add_index :codemarks, :created_at
    add_index :codemarks, :resource_id
    add_index :codemarks, :resource_type
    add_index :codemarks, [:resource_id, :resource_type, :created_at]
  end
end
