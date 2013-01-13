class AddSnapshotUrlToLinkRecords < ActiveRecord::Migration
  def change
    add_column :link_records, :snapshot_url, :string
  end
end
