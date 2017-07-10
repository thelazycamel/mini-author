class LearningObject < ActiveRecord::Migration

  def change
    create_table :learning_objects do |t|
      t.integer  :site_id
      t.string   :name
      t.string   :lo
      t.string   :upload_response
      t.timestamps
    end
  end

end
