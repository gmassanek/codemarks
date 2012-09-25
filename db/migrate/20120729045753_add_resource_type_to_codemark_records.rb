class AddResourceTypeToCodemarkRecords < ActiveRecord::Migration
  def change
    add_column :codemark_records, :resource_type, :string
  end
end
