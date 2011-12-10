class AddSavesCountToLink < ActiveRecord::Migration
  def change
    add_column :links, :link_saves_count, :integer, :default => 0
  end
end
