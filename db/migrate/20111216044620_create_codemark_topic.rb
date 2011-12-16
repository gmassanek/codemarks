class CreateCodemarkTopic < ActiveRecord::Migration
  def change
    create_table :codemark_topics do |t|
      t.integer :codemark_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
