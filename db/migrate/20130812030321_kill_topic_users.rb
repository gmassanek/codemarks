class KillTopicUsers < ActiveRecord::Migration
  def up
    remove_column :topics, :user_id
  end

  def down
    add_column :topics, :user_id, :integer
  end
end
