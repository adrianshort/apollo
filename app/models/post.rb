class Post
  belongs_to :feed
  
  EARTH_RADIUS_M = 6378000
  
  def self.near(lat, lng, radius_m)
    all(
      :loc => {
        '$nearSphere' => [ lng, lat ],
        '$maxDistance' => radius_m / EARTH_RADIUS_M
    })
  end
end
