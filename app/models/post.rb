class Post < ActiveRecord::Base
  belongs_to :feed
  
  EARTH_RADIUS_METRES = 6378000
  
  def self.near(lat, lon, radius_metres)
    # Santize inputs. Is this necessary?
    lat = lat.to_f
    lon = lon.to_f
    radius_metres = radius_metres.to_i

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
        ( #{EARTH_RADIUS_METRES}
        * acos( cos( radians('#{lat}') )
        * cos( radians( p.lat ) )
        * cos( radians( p.lon )
        - radians('#{lon}') )
        + sin( radians('#{lat}') )
        * sin( radians( p.lat ) ) ) )
        < #{radius_metres}
        
      ORDER BY distance

      ENDQUERY
    )
  end
end
