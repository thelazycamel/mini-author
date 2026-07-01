class CreateSites < ActiveRecord::Migration[7.2]
  def change
    create_table :sites do |t|
      t.string :name, null: false, limit: 255
      t.string :domain, null: false, limit: 255
      t.string :path, limit: 255
      t.string :port, limit: 10

      t.timestamps
    end
  end
end
