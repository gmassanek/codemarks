class AddTitleToCodemarkRecord < ActiveRecord::Migration
  def change
    add_column :codemark_records, :title, :text
  end
end
