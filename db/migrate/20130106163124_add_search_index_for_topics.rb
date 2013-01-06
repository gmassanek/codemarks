class AddSearchIndexForTopics < ActiveRecord::Migration
  def up
    add_column :topics, :search, 'tsvector'

    execute <<-SQL
      CREATE TRIGGER topics_search_update
        BEFORE INSERT OR UPDATE ON topics
        FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(search,
                                  'pg_catalog.english',
                                  title,
                                  slug);
    SQL

    execute <<-SQL

    UPDATE topics
      SET search = to_tsvector('english', title || ' ' || slug);

    SQL
  end

  def down
    remove_column :topics, :search
    execute 'DROP TRIGGER IF EXISTS topics_search_update ON topics;'
  end
end
