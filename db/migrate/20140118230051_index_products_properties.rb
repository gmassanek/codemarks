class IndexProductsProperties < ActiveRecord::Migration
  def up
    execute "CREATE INDEX resources_indexed_properties ON resources USING GIN(indexed_properties)"
    add_index :resources, :author_id
    add_index :resources, :created_at
    add_index :resources, :type
    add_index :resources, :codemarks_count
    add_index :resources, :clicks_count
  end

  def down
    execute "DROP INDEX resources_indexed_properties"
    drop_index :resources, :author_id
    drop_index :resources, :created_at
    drop_index :resources, :type
    drop_index :resources, :codemarks_count
    drop_index :resources, :clicks_count
  end
end
