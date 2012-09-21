class ChangeLinkRecordToResource < ActiveRecord::Migration
  def up
    rename_column :codemark_records, :link_record_id, :resource_id
  end

  def down
    rename_column :codemark_records, :resource_id, :link_record_id
  end
end
