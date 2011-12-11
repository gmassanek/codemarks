class AddArchivedFieldToLinkSaves < ActiveRecord::Migration
  def change
    add_column :link_saves, :archived, :boolean, :default => false
  end
end
