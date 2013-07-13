class PolymorphiseClick < ActiveRecord::Migration
  def up
    rename_column :clicks, :link_record_id, :resource_id
    add_column :clicks, :resource_type, :string

    execute <<-SQL
      UPDATE clicks
      SET resource_type='LinkRecord'
    SQL
  end

  def down
    rename_column :clicks, :resource_id, :link_record_id
    remove_column :clicks, :resource_type
  end
end
