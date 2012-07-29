class AddTypeToResources < ActiveRecord::Migration
  def change
    add_column :link_records, :resource_type, :string, :default => 'link'
    add_column :text_records, :resource_type, :string, :default => 'text'
  end
end
