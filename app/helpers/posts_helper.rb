module PostsHelper
  def post_to_poi(post)
    # http://layar.com/documentation/browser/api/getpois-response/
    {
      :id => post._id,
      :imageURL => "%s%s/assets/layar-icons/tal-logo-100.png" % [ request.protocol, request.env['HTTP_HOST'] ],
      :anchor =>  {
        :geolocation => {
          :lat => post.loc['lat'],
          :lon => post.loc['lng'],
          :alt => 0
        }
      },
      :text => {
        :title =>       post.title,
        :description => clean_description(post.summary),
        :footnote =>    "From #{post.feed.title}"
      },
      :actions => [
        {
          :label =>         "Read more...",
          :uri =>           post.url,
          :contentType =>   "text/html",
          :method =>        "GET",
          :activityType =>  1
        }
      ]
    }
  end
  
  def clean_description(s)
    if s.size > 137
      s = s[0..136] + '...'
    end
    
    coder = HTMLEntities.new
    coder.decode(s.gsub(/<.+?>/, ''))
  end
end
