class AddAuthorToLink < ActiveRecord::Migration
  def change
    add_column :link_records, :author_id, :integer
  end
end
