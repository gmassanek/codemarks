class RenameNoteToDescription < ActiveRecord::Migration
  def up
    rename_column :codemark_records, :note, :description
    execute('DROP TRIGGER codemarks_search_update on codemark_records;')
    execute <<-SQL
    CREATE TRIGGER codemarks_search_update
    BEFORE INSERT OR UPDATE ON codemark_records
    FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(search,
                              'pg_catalog.english',
                              title,
                              description);
    SQL

    execute "UPDATE codemark_records SET search = to_tsvector('english', title || ' ' || description);"
  end

  def down
    rename_column :codemark_records, :description, :note
    execute('DROP TRIGGER codemarks_search_update on codemark_records;')
    execute <<-SQL
    CREATE TRIGGER codemarks_search_update
    BEFORE INSERT OR UPDATE ON codemark_records
    FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(search,
                              'pg_catalog.english',
                              title,
                              note);
    SQL

    execute "UPDATE codemark_records SET search = to_tsvector('english', title || ' ' || note);"
  end
end
