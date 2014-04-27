class UpdateResourceSearch2 < ActiveRecord::Migration
  def up
    execute <<-SQL
    CREATE OR REPLACE FUNCTION resources_trigger() RETURNS trigger AS $$
    begin
      new.search :=
         setweight(to_tsvector('pg_catalog.english', coalesce(new.indexed_properties->'title', new.properties->'title','')), 'A') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.indexed_properties->'description',new.properties->'description','')), 'B') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.properties->'text','')), 'B') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.indexed_properties->'host','')), 'C') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.indexed_properties->'url','')), 'C') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.indexed_properties->'owner_login','')), 'C') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.properties->'site_data','')), 'D');
      return new;
    end
    $$ LANGUAGE plpgsql;

    UPDATE resources SET updated_at = updated_at;
    SQL
  end

  def down
    execute <<-SQL

    CREATE OR REPLACE FUNCTION resources_trigger() RETURNS trigger AS $$
    begin
      new.search :=
         setweight(to_tsvector('pg_catalog.english', coalesce(new.properties->'title','')), 'A') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.properties->'text','')), 'C') ||
         setweight(to_tsvector('pg_catalog.english', coalesce(new.properties->'site_data','')), 'C');
      return new;
    end
    $$ LANGUAGE plpgsql;

    SQL
  end
end
