class AddTimestampsToClicks < ActiveRecord::Migration
  def change
    add_column :clicks, :created_at, :time
    add_column :clicks, :updated_at, :time
  end
end
