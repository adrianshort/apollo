class PostPublishedChangeToDatetime < ActiveRecord::Migration
  def up
    remove_column :posts, :published
    add_column :posts, :published, :datetime
  end

  def down
    remove_column :posts, :published
    add_column :posts, :published, :time
  end
end
