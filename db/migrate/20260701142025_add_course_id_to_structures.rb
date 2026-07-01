class AddCourseIdToStructures < ActiveRecord::Migration[7.2]
  def change
    add_column :structures, :course_id, :string
  end
end
