class AddExtensionPgTrgm < ActiveRecord::Migration[5.2]
  def up
    execute('CREATE EXTENSION pg_trgm;')
  end

  def down
    execute('DROP EXTENSION pg_trgm;')
  end
end