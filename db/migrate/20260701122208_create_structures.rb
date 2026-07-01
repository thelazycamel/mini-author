class CreateStructures < ActiveRecord::Migration[7.2]
  def change
    create_table :structures do |t|
      t.references :site, null: false, foreign_key: true
      t.string :name, null: false, limit: 255
      t.string :structure_xml
      t.string :upload_response

      t.timestamps
    end
  end
end
