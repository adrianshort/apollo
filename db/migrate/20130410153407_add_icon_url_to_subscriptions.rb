class AddIconUrlToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :icon_url, :string
  end
end
