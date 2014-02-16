class AddSourceToCodemarks < ActiveRecord::Migration
  def change
    add_column :codemarks, :source, :text
  end
end
