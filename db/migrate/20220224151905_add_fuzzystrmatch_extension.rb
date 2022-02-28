class AddFuzzystrmatchExtension < ActiveRecord::Migration[5.2]
  def up
    execute('CREATE EXTENSION fuzzystrmatch;')
  end

  def down
    execute('DROP EXTENSION fuzzystrmatch;')
  end
end

