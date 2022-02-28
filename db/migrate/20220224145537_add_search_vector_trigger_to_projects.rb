class AddSearchVectorTriggerToProjects < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION fill_search_vector_for_project() RETURNS trigger LANGUAGE plpgsql AS $$
      declare

      begin
        new.search_vector :=
          setweight(to_tsvector('pg_catalog.#{Rails.application.secrets.postgres_language_analyzer}', unaccent(coalesce(new.name, ''))), 'A') ||
          setweight(to_tsvector('pg_catalog.#{Rails.application.secrets.postgres_language_analyzer}', unaccent(coalesce(new.tags, ''))), 'B') ||
          setweight(to_tsvector('pg_catalog.#{Rails.application.secrets.postgres_language_analyzer}', unaccent(coalesce(new.description, ''))), 'C') ||
          setweight(to_tsvector('pg_catalog.#{Rails.application.secrets.postgres_language_analyzer}', unaccent(coalesce(new.steps_body, ''))), 'D');

        return new;
      end
      $$;
    SQL

    execute <<-SQL
      CREATE TRIGGER projects_search_content_trigger BEFORE INSERT OR UPDATE
        ON projects FOR EACH ROW EXECUTE PROCEDURE fill_search_vector_for_project();
    SQL

    Project.find_each(&:touch)
  end

  def down
    execute <<-SQL
      DROP TRIGGER projects_search_content_trigger ON projects;
      DROP FUNCTION fill_search_vector_for_project();
    SQL
  end
end
