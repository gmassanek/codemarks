class CreateResources < ActiveRecord::Migration
  def up
    create_table :resources do |t|
      t.integer :author_id
      t.integer :clicks_count, :default => 0
      t.integer :codemarks_count, :default => 0
      t.string :type
      t.hstore :properties
      t.hstore :indexed_properties
      t.tsvector :search

      t.timestamps
    end
  end

  def down
    drop_table :resources
  end
end
