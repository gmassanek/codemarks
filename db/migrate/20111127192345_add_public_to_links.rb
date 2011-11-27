class AddPublicToLinks < ActiveRecord::Migration
  def change
    add_column :links, :public, :boolean, :default => true
  end
end
