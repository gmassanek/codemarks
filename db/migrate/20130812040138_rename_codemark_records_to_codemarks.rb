class RenameCodemarkRecordsToCodemarks < ActiveRecord::Migration
  def up
    rename_table :codemark_records, :codemarks
    rename_column :codemark_topics, :codemark_record_id, :codemark_id
  end

  def down
    rename_table :codemarks, :codemark_records
    rename_column :codemark_topics, :codemark_id, :codemark_record_id
  end
end
