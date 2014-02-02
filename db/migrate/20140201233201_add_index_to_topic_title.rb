class AddIndexToTopicTitle < ActiveRecord::Migration
  def change
    add_index :topics, :title
  end
end
