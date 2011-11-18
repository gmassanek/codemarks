class AddLinkCountToLinks < ActiveRecord::Migration
  def change
    add_column :links, :save_count, :integer, :default => 1
  end
end
