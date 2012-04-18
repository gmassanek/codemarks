class AddNoteToCodemark < ActiveRecord::Migration
  def change
    add_column :codemark_records, :note, :text
  end
end
