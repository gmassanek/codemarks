class AddClickCountToLinks < ActiveRecord::Migration
  def change
    add_column :links, :clicks_count, :integer, :default => 0
  end
end
