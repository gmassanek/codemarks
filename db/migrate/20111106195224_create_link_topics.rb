class CreateLinkTopics < ActiveRecord::Migration
  def change
    create_table :link_topics do |t|
      t.integer :link_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
