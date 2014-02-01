class IndexTweaks < ActiveRecord::Migration
  def up
    remove_index "codemarks", ["resource_id", "resource_type", "created_at"]
    add_index "codemarks", ["resource_id", "created_at"]
  end

  def down
    add_index "codemarks", ["resource_id", "resource_type", "created_at"]
    remove_index "codemarks", ["resource_id", "created_at"]
  end
end
