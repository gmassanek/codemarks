class RemoveSiteDataFromLinks < ActiveRecord::Migration
  def up
    remove_column :links, :site_content
  end

  def down
    add_column :links, :site_content, :text
  end
end
