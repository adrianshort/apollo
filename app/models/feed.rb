class Feed
  include MongoMapper::Document

  key :title,         String, :default => "[New feed - hasn't been fetched yet]"
  key :feed_url,      String  # The URL of the RSS feed, not the website that owns it
  key :url,           String  # The URL of website. Called "link" in RSS 2.0
  key :description,   String
  key :guid,          String # Atom id or RSS guid
  key :generator,     String
  key :last_fetched,  Time, :default => nil
  timestamps!

  many :posts, :dependent => :destroy

  validates :title, :presence => true
  validates_format_of :feed_url, :with => URI::regexp(%w(http https)), :message => "must be a valid URL"
  
  after_create  :get
  
  # Fetch and parse feed contents from web

  def self.get_all
    Feed.all.each { |f| f.get }
  end

  def get
    puts "Fetching feed: #{@url}"
    Feedzirra::Feed.add_common_feed_entry_element('georss:point', :as => :point)
    Feedzirra::Feed.add_common_feed_entry_element('geo:lat', :as => :geo_lat)
    Feedzirra::Feed.add_common_feed_entry_element('geo:long', :as => :geo_long)
    Feedzirra::Feed.add_common_feed_element('generator', :as => :generator)

    feed = Feedzirra::Feed.fetch_and_parse(@feed_url)

    self.set(
      :title =>         feed.title,
      :url =>           feed.url,
      :description =>   feed.description,
      :generator =>     feed.generator,
      :last_fetched =>  Time.now
    )

    feed.entries.each do |e|
    
      if e.geo_lat && e.geo_long
        latlng = [e.geo_lat, e.geo_long]
      elsif e.point
        latlng = e.point.split(' ')
      else
        next
      end      

      attrs = {
        :title =>     e.title,
        :url =>       e.url,
        :author =>    e.author,
        :summary =>   e.summary,
        :content =>   e.content,
        :published => e.published,
        :guid =>      e.id,
        :loc => {
          :lng => latlng[1].to_f,
          :lat => latlng[0].to_f
        }
      }
      
      if Post.where(:url => e.url).size == 0
        self.posts << Post.create(attrs)
      else
        Post.set({:url => e.url}, attrs)
      end
      
    end
    
  end
  
end
