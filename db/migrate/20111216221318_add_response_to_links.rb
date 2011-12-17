class AddResponseToLinks < ActiveRecord::Migration
  def change
    add_column :links, :response, :text
  end
end
