class AddIconUrlToLayers < ActiveRecord::Migration
  def change
  	add_column :layers, :icon_url, :string
  end
end
