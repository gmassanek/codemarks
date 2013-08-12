class KillPopularity < ActiveRecord::Migration
  def up
    remove_column :link_records, :popularity
  end

  def down
    add_column :link_records, :popularity, :integer, :default => 0
  end
end
