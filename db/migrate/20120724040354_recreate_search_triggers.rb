class RecreateSearchTriggers < ActiveRecord::Migration
  def up
    execute <<-SQL
      DROP TRIGGER IF EXISTS codemarks_search_update ON codemark_records;
      CREATE TRIGGER codemarks_search_update
        BEFORE INSERT OR UPDATE ON codemark_records
        FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(search,
                                  'pg_catalog.english',
                                  title,
                                  description);
    SQL

    execute <<-SQL

    UPDATE codemark_records 
      SET search = to_tsvector('english', title || ' ' || description);

    SQL
  end

  def down
    execute 'DROP TRIGGER IF EXISTS codemarks_search_update ON codemark_records;'
  end
end
