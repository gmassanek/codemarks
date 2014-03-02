class ChangeUserDescriptionFromStringToText < ActiveRecord::Migration
  def up
    change_column :users, :description, :text
  end

  def down
    change_column :users, :description, :string
  end
end
