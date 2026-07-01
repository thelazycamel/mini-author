class AddStructurePathToSites < ActiveRecord::Migration[7.2]
  def change
    add_column :sites, :structure_path, :string
  end
end
