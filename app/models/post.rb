class Post < ActiveRecord::Base
  belongs_to :feed
  validates :title, :presence => true
  validates :lat, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }
  validates :lon, :numericality => { :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180 }
  
  EARTH_RADIUS_METRES = 6378000
  
  def self.near(lat, lon, radius_metres, layer_id)
    # Santize inputs. Is this necessary?
    lat = lat.to_f
    lon = lon.to_f
    radius_metres = radius_metres.to_i
    layer_id = layer_id.to_i

    # Calculate distance using the Haversine formula  
    self.find_by_sql(<<-ENDQUERY
      SELECT
        p.id,
        p.title,
        p.summary,
        p.url,
        p.lat,
        p.lon,
        p.published,
        p.feed_id,
        f.title as feed_title,
        ( #{EARTH_RADIUS_METRES}
        * acos( cos( radians('#{lat}') )
        * cos( radians( p.lat ) )
        * cos( radians( p.lon )
        - radians('#{lon}') )
        + sin( radians('#{lat}') )
        * sin( radians( p.lat ) ) ) )
        As distance

      FROM posts p
      INNER JOIN feeds f
      ON p.feed_id = f.id
      
      WHERE
        p.id IN
        ( -- Subquery returns a list of post_ids for posts on this layer
          SELECT p.id

          FROM subscriptions s
          
          INNER JOIN feeds f
          ON s.feed_id = f.id

          INNER JOIN posts p
          ON p.feed_id = f.id

          WHERE s.layer_id = #{layer_id}
        )
          
        AND
        (
          #{EARTH_RADIUS_METRES}
          * acos( cos( radians('#{lat}') )
          * cos( radians( p.lat ) )
          * cos( radians( p.lon )
          - radians('#{lon}') )
          + sin( radians('#{lat}') )
          * sin( radians( p.lat ) ) )
        )
        <= #{radius_metres}
        
      ORDER BY distance

      ENDQUERY
    )
  end
end
