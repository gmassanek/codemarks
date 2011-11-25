class ChangeClicksTimesToDatetimes < ActiveRecord::Migration
  def up
    change_column :clicks, :created_at, :datetime
    change_column :clicks, :updated_at, :datetime
  end

  def down
    change_column :clicks, :created_at, :time
    change_column :clicks, :updated_at, :time
  end
end
