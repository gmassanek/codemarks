class KillGlobalTopics < ActiveRecord::Migration
  def up
    remove_column :topics, :global
  end

  def down
    add_column :topics, :global, :boolean, :default => false
  end
end
