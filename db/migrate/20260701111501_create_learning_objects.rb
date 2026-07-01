class CreateLearningObjects < ActiveRecord::Migration[7.2]
  def change
    create_table :learning_objects do |t|
      t.references :site, null: false, foreign_key: true
      t.string :name, null: false, limit: 255
      t.string :lo
      t.string :upload_response
      t.string :info_xml

      t.timestamps
    end
  end
end
