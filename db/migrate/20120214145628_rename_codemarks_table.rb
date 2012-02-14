class RenameCodemarksTable < ActiveRecord::Migration
  def up
    rename_table :codemarks, :codemark_records
  end

  def down
    rename_table :codemark_records, :codemarks
  end
end
