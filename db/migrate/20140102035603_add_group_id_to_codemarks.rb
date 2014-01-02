class AddGroupIdToCodemarks < ActiveRecord::Migration
  def change
    add_column :codemarks, :group_id, :integer
  end
end
