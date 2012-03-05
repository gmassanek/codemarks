class RenameLinksToLinkRecords < ActiveRecord::Migration
  def up
    rename_table :links, :link_records
  end

  def down
    rename_table :link_records, :links
  end
end
