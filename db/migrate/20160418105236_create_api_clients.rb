class CreateAPIClients < ActiveRecord::Migration[5.0]
  def change
    create_table :api_clients do |t|
      t.string :name, null: false, default: ""
      t.integer :calls_count, null: false, default: 0
      t.string :app_id, null: false
      t.string :app_secret, null: false
      t.string :origin, null: false

      t.timestamps
    end
  end
end
