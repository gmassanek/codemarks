class AddPrivateToCodemarks < ActiveRecord::Migration
  def change
    add_column :codemark_records, :private, :boolean, :default => false
  end
end
