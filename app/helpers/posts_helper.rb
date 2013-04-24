module PostsHelper
  def post_to_poi(post, subscription)
    # http://layar.com/documentation/browser/api/getpois-response/

    if subscription.layer.icon_url.blank?
      image_url = "%s%s/assets/layar-icons/tal-logo-100.png" % [ request.protocol, request.env['HTTP_HOST'] ]
    else
      image_url = subscription.layer.icon_url
    end

    res = {
      :id => post.id,
      :imageURL => image_url,
      :anchor =>  {
        :geolocation => {
          :lat => post.lat,
          :lon => post.lon,
          :alt => 0
        }
      },
      :text => {
        :title =>       decode_entities(post.title),
        :description => clean_description(post.summary),
        :footnote =>    "From #{post.feed_title}"
      },
      :actions => [
        {
          :label =>         "Read more...",
          :uri =>           post.url,
          :contentType =>   "text/html",
          :method =>        "GET",
          :activityType =>  1
        },
      ]
    }

    unless subscription.icon_url.blank?
      res[:object] = {
        :contentType => "image/vnd.layar.generic",
        :url => subscription.icon_url,
        :reducedURL => subscription.icon_url,
        :size => subscription.icon_size      
      }

      # http://layar.com/documentation/browser/api/getpois-response/hotspots/
      res[:transform] = {
        :rotate => {  
           :rel => true,    
           :axis => { :x => 0, :y => 0, :z => 1 },
           :angle => 0   
        },  
        :translate => { :x => 0, :y => -0.075, :z => 0 },  
        :scale => 1.0
      }
    end
    res
  end
  
  def decode_entities(s)
    HTMLEntities.new.decode s
  end
  
  def clean_description(s)
    if s.nil?
      return ""
    end
  
    if s.size > 137
      s = s[0..136] + '...'
    end
    
    decode_entities(s.gsub(/<.+?>/, ''))
  end
end
