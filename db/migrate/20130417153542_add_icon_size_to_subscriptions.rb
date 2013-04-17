class AddIconSizeToSubscriptions < ActiveRecord::Migration
  def up
  	add_column :subscriptions, :icon_size, :integer, :default => 12
  	Subscription.all.each { |s| s.update_attribute :icon_size, 12 }
  end

  def down
  	remove_column :subscriptions, :icon_size
  end
end
