class CreateTextRecord < ActiveRecord::Migration
  def up
    create_table :text_records do |t|
      t.text :text
      t.string :title

      t.timestamps
    end
  end

  def down
    drop_table :text_records
  end
end
