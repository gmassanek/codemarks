class RenameLinkRecordToLink < ActiveRecord::Migration
  def up
    rename_table :link_records, :links
    execute "UPDATE codemark_records SET resource_type = 'Link' WHERE resource_type = 'LinkRecord'"
  end

  def down
    rename_table :links, :link_records
    execute "UPDATE codemark_records SET resource_type = 'LinkRecord' WHERE resource_type = 'Link'"
  end
end
