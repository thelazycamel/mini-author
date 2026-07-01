class AddApiTokenToSites < ActiveRecord::Migration[7.2]
  def change
    add_column :sites, :api_token, :string
  end
end
