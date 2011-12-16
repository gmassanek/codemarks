class ChangeLinkSaveCountToCodemarksCount < ActiveRecord::Migration
  def up
    rename_column :links, :link_saves_count, :codemarks_count
  end

  def down
    rename_column :links, :codemarks_count, :link_saves_count
  end
end
