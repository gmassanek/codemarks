class AddUserToLinkTopics < ActiveRecord::Migration
  def change
    add_column :link_topics, :user_id, :integer
  end
end
