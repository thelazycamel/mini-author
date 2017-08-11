class AddInfoXmlToLearningObject < ActiveRecord::Migration

  def change
    add_column :learning_objects, :info_xml, :string
  end

end
