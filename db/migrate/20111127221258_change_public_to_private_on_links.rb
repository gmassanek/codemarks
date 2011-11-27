class ChangePublicToPrivateOnLinks < ActiveRecord::Migration
  def up
    change_column :links, :public, :boolean, :default => false
    rename_column :links, :public, :private
  end

  def down
    rename_column :links, :private, :public
    change_column :links, :public, :boolean, :default => true
  end
end
