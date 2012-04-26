class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :codemark_id
      t.integer :author_id
      t.integer :text

      t.timestamps
    end

    add_index :comments, :author_id
  end
end
