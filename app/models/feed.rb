class Feed
  include MongoMapper::Document

  key :title, String, :default => "[New feed - hasn't been fetched yet]"
  key :link, String
  key :last_fetched, Time, :default => nil
  timestamps!

  validates :title, :link, :presence => true
  validates_format_of :link, :with => URI::regexp(%w(http https)), :message => "must be a valid URL"
end
