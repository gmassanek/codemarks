class UpdateResourceSearch < ActiveRecord::Migration
  def up
    execute <<-SQL
    CREATE INDEX resources_search_index
    ON resources USING gin(search);

    CREATE FUNCTION resources_trigger() RETURNS trigger AS $$
    begin
      new.search :=
         setweight(to_tsvector('pg_catalog.english', coalesce(new.properties->'title','')), 'A') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.properties->'text','')), 'C') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.properties->'site_data','')), 'C');
      return new;
    end
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER resources_search_update BEFORE INSERT OR UPDATE
        ON resources FOR EACH ROW EXECUTE PROCEDURE resources_trigger();
    SQL
  end

  def down
    execute 'DROP INDEX resources_search_index'
    execute 'DROP TRIGGER resources_search_update ON resources;'
    execute 'DROP FUNCTION resources_trigger();'
  end
end
