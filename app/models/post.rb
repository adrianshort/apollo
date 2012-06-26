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

  ensure_index [[:loc, '2d']]

  belongs_to :feed
  
  EARTH_RADIUS_KM = 6378.0
  
  def self.near(lat, lng, radius_km)
    all(
      :loc => {
        '$nearSphere' => [ lng, lat ],
        '$maxDistance' => radius_km / EARTH_RADIUS_KM
    })
  end
end
