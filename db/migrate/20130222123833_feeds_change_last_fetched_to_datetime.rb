class FeedsChangeLastFetchedToDatetime < ActiveRecord::Migration
  def up
    remove_column :feeds, :last_fetched
    add_column :feeds, :last_fetched, :datetime
  end

  def down
    remove_column :feeds, :last_fetched
    add_column :feeds, :last_fetched, :time
  end
end
