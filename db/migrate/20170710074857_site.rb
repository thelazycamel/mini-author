class Site < ActiveRecord::Migration

  def change
    create_table :sites do |t|
      t.string   :name
      t.string   :domain
      t.string   :path
      t.string   :port
      t.timestamps
    end
  end

end
