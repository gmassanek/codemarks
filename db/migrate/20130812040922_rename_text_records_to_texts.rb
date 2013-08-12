class RenameTextRecordsToTexts < ActiveRecord::Migration
  def up
    rename_table :text_records, :texts
    execute "UPDATE codemarks SET resource_type = 'Text' WHERE resource_type = 'TextRecord'"
  end

  def down
    rename_table :texts, :text_records
    execute "UPDATE codemarks SET resource_type = 'TextRecord' WHERE resource_type = 'Text'"
  end
end
