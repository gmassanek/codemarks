class AddSearchToResources < ActiveRecord::Migration
  def up
    add_column :links, :search, 'tsvector'
    add_column :texts, :search, 'tsvector'

    execute <<-SQL
    CREATE INDEX links_search_index
    ON links USING gin(search);

    CREATE INDEX texts_search_index
    ON texts USING gin(search);

    CREATE TRIGGER links_search_update
    BEFORE INSERT OR UPDATE ON links
    FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(search,
                              'pg_catalog.english',
                              title,
                              site_data,
                              host);

    CREATE TRIGGER texts_search_update
    BEFORE INSERT OR UPDATE ON texts
    FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(search,
                              'pg_catalog.english',
                              title,
                              text);
    SQL

    execute "UPDATE links SET search = to_tsvector('english', title || ' ' || site_data || ' ' || host);"
    execute "UPDATE texts SET search = to_tsvector('english', title || ' ' || text);"
  end

  def down
    remove_column :links, :search
    remove_column :texts, :search
    execute 'DROP TRIGGER links_search_update ON links;'
    execute 'DROP TRIGGER texts_search_update ON texts;'
  end
end
