class RenameLinkResponse < ActiveRecord::Migration
  def up
    rename_column :links, :response, :site_data
  end

  def down
    rename_column :links, :site_data, :response
  end
end
