class RenameLinkSavesToCodemarks < ActiveRecord::Migration
  def up
    rename_table :link_saves, :codemarks
  end

  def down
    rename_table :codemarks, :link_saves
  end
end
