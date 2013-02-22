class AddGuidToPostsRemoveGuidFromFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :guid
    add_column :posts, :guid, :string
  end
end
