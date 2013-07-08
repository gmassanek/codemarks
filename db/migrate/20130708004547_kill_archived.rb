class KillArchived < ActiveRecord::Migration
  def up
    remove_column :codemark_records, :archived
  end

  def down
    add_column :codemark_records, :archived, :boolean, :default => false
  end
end
