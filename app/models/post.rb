class Post
  include MongoMapper::Document

  key :title,       String
  key :url,         String
  key :author,      String
  key :summary,     String
  key :content,     String
  key :published,   Time
  key :loc,         Hash # { lng, lat }
  timestamps!

  belongs_to :feed
end
