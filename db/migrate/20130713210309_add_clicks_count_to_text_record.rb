class AddClicksCountToTextRecord < ActiveRecord::Migration
  def change
    add_column :text_records, :clicks_count, :integer, :default => 0
  end
end
