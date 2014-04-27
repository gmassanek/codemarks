class AddIndexOnGroupIdToTopics < ActiveRecord::Migration
  def change
    add_index :topics, :group_id
  end
end
