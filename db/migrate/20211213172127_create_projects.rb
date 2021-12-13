class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :slug
      t.references :client, foreign_key: true
      t.number :remote_id
      t.string :name
      t.text :description
      t.arraystring :tags
      t.string :machines, array: true
    end
  end
end
