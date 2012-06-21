class Feed
  include MongoMapper::Document

  key :title,         String, :default => "[New feed - hasn't been fetched yet]"
  key :feed_url,      String  # The URL of the RSS feed, not the website that owns it
  key :url,           String  # The URL of website. Called "link" in RSS 2.0
  key :description,   String
  key :last_fetched,  Time, :default => nil
  timestamps!

  many :posts, :dependent => :destroy

  validates :title, :presence => true
  validates_format_of :feed_url, :with => URI::regexp(%w(http https)), :message => "must be a valid URL"
  
  after_create  :get
  
  # Fetch and parse feed contents from web
  def get
    Feedzirra::Feed.add_common_feed_entry_element('georss:point', :as => :point)

    feed = Feedzirra::Feed.fetch_and_parse(@feed_url)

    self.set(
      :title =>         feed.title,
      :url =>           feed.url,
      :description =>   feed.description,
      :last_fetched =>  Time.now
    )

    feed.entries.each do |e|
#       puts "#{e.title} point: #{e.point}"
      
      latlng = e.point.split(' ')
      
      self.posts << Post.create(
        :title =>     e.title,
        :url =>       e.url,
        :author =>    e.author,
        :summary =>   e.summary,
        :content =>   e.content,
        :published => e.published,
        :loc => {
          :lng => latlng[1].to_f,
          :lat => latlng[0].to_f
        }
      )
    end
    
  end
  
end
