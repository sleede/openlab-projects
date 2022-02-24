class AddExtensionUnaccent < ActiveRecord::Migration[5.2]
  def up
    execute('CREATE EXTENSION unaccent;')
  end

  def down
    execute('DROP EXTENSION unaccent;')
  end
end