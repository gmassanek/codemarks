class RenamingLinkColumnsToLinkRecord < ActiveRecord::Migration
  def up
    rename_column :clicks, :link_id, :link_record_id
    rename_column :codemark_records, :link_id, :link_record_id
    rename_column :link_topics, :link_id, :link_record_id
  end

  def down
    rename_column :clicks, :link_record_id, :link_id
    rename_column :codemark_records, :link_record_id, :link_id
    rename_column :link_topics, :link_record_id, :link_id
  end
end
