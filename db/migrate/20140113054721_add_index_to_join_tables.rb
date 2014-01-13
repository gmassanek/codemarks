class AddIndexToJoinTables < ActiveRecord::Migration
  def change
    add_index :codemark_topics, :codemark_id
    add_index :codemark_topics, :topic_id
    add_index :clicks, :user_id
    add_index :clicks, [:resource_id, :resource_type]
    add_index :codemarks, :user_id
    add_index :codemarks, [:resource_id, :resource_type]
    add_index :codemarks, :group_id
    add_index :groups_users, :group_id
    add_index :groups_users, :user_id
    add_index :links, :private
    add_index :links, :clicks_count
    add_index :links, :codemarks_count
    add_index :links, :author_id
    add_index :texts, :author_id
    add_index :texts, :clicks_count
    add_index :users, :nickname
  end
end
