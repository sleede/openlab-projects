class AddSearchVectorToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :search_vector, :tsvector
    add_index :projects, :search_vector, using: :gin
  end
end
