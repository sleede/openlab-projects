class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :slug
      t.references :api_client, foreign_key: true, index: true
      t.integer :project_id
      t.string :name
      t.text :description
      t.text :tags
      t.string :machines, array: true
      t.string :components, array: true
      t.string :themes, array: true
      t.string :author
      t.string :collaborators, array: true
      t.text :steps_body
      t.string :image_path
      t.string :project_path
      t.datetime :published_at
      t.timestamps
    end
  end
end
