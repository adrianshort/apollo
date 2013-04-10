class ConvertFeedsLayersTableToSubscriptions < ActiveRecord::Migration
  def change
  	rename_table :feeds_layers, :subscriptions
    add_column :subscriptions, :id, :primary_key
    add_index :subscriptions, :id, :name => "id"
  end
end
