class ChangeCodemarksIdToNewName < ActiveRecord::Migration
  def up
    rename_column :codemark_topics, :codemark_id, :codemark_record_id
  end

  def down
    rename_column :codemark_topics, :codemark_record_id, :codemark_id
  end
end
