class AddGlobalToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :global, :boolean, :default => true
  end
end
