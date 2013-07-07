class AddAuthorToTextRecord < ActiveRecord::Migration
  def change
    add_column :text_records, :author_id, :integer
  end
end
