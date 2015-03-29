class RenameCodemarkTopics < ActiveRecord::Migration
  def up
    rename_table :codemark_topics, :codemarks_topics
    remove_column :codemarks_topics, :created_at
    remove_column :codemarks_topics, :updated_at
  end

  def down
    rename_table :codemarks_topics, :codemark_topics
    add_column :codemark_topics, :created_at, :datetime, :null => false
    add_column :codemark_topics, :updated_at, :datetime, :null => false
  end
end
