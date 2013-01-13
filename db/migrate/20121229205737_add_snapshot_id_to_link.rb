class AddSnapshotIdToLink < ActiveRecord::Migration
  def change
    add_column :link_records, :snapshot_id, :string
  end
end
