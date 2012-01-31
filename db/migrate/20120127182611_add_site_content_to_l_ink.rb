class AddSiteContentToLInk < ActiveRecord::Migration
  def change
    add_column :links, :site_content, :text
  end
end
