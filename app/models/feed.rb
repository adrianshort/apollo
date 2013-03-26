class Feed < ActiveRecord::Base
  include HerokuDelayedJobAutoscale::Autoscale
  has_many :posts, :dependent => :destroy
  has_and_belongs_to_many :layers
  attr_accessible :title, :url, :description, :generator, :last_fetched, :feed_url
  attr_accessor :new_layer_id # non model attribute used when creating new feeds from within a layer

  validates_format_of :feed_url, :with => URI::regexp(%w(http https)), :message => "must be a valid URL"
  
  after_create  :fetch
  
  def self.fetch_all
    Feed.all.each { |f| f.delay.fetch }
  end

  # Fetch and parse feed contents from web
  def fetch
    puts "Fetching feed: #{self.feed_url}"
    Feedzirra::Feed.add_common_feed_entry_element('georss:point', :as => :point)
    Feedzirra::Feed.add_common_feed_entry_element('geo:lat', :as => :geo_lat)
    Feedzirra::Feed.add_common_feed_entry_element('geo:long', :as => :geo_long)
    Feedzirra::Feed.add_common_feed_element('generator', :as => :generator)

    feed = Feedzirra::Feed.fetch_and_parse(self.feed_url)

    self.update_attributes(
      :title =>         feed.title,
      :url =>           feed.url,
      :description =>   feed.description,
      :generator =>     feed.generator,
      :last_fetched =>  DateTime.now
    )

    feed.entries.each do |e|
    
      if e.geo_lat && e.geo_long
        latlon = [e.geo_lat, e.geo_long]
      elsif e.point
        latlon = e.point.split(' ')
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
        :lon =>       latlon[1].to_f,
        :lat =>       latlon[0].to_f
      }
      
      # Create a new post or update an existing one
      post = Post.find_or_initialize_by_url(e.url)
      post.feed = self
      post.assign_attributes(attrs)
      post.save
    end
  end
end
