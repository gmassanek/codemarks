class AddSearchFieldToCodemarks < ActiveRecord::Migration
  def change
    add_column :codemark_records, :search, 'tsvector'

    execute <<-SQL
    CREATE INDEX codemarks_search_index
    ON codemark_records USING gin(search);

    CREATE TRIGGER codemarks_search_update
    BEFORE INSERT OR UPDATE ON codemark_records
    FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(search,
                              'pg_catalog.english',
                              title,
                              note);
    SQL

    execute "UPDATE codemark_records SET search = to_tsvector('english', title || ' ' || note)"
  end
end
