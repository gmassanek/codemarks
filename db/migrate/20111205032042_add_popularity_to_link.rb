class AddPopularityToLink < ActiveRecord::Migration
  def change
    add_column :links, :popularity, :integer, :default => 0
  end
end
