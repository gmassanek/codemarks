class DeleteResourceTabls < ActiveRecord::Migration
  def up
    drop_table :links
    drop_table :texts
  end

  def down
  end
end
