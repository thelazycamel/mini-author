class AddCoverImageUrlToStructures < ActiveRecord::Migration[7.2]
  def change
    add_column :structures, :cover_image_url, :string
  end
end
