module PostsHelper
  def post_to_poi(post, subscription)
    # http://layar.com/documentation/browser/api/getpois-response/
    res = {
      :id => post.id,
      :imageURL => "%s%s/assets/layar-icons/tal-logo-100.png" % [ request.protocol, request.env['HTTP_HOST'] ],
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
        :size => 10        
      }
      res[:transform] = {
        :rel => true # icon always faces the user
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
