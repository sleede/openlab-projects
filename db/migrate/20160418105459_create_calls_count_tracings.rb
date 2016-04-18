class CreateCallsCountTracings < ActiveRecord::Migration[5.0]
  def change
    create_table :calls_count_tracings do |t|
      t.belongs_to :api_client, foreign_key: true, index: true
      t.integer :calls_count, null: false
      t.datetime :at, null: false

      t.timestamps
    end
  end
end
