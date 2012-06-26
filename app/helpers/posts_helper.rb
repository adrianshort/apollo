module PostsHelper
  def post_to_poi(post)
    # http://layar.com/documentation/browser/api/getpois-response/
    {
      :id => post._id,
      :anchor =>  {
        :geolocation => {
          :lat => post.loc['lat'],
          :lon => post.loc['lng'],
          :alt => 0
        }
      },
      :title => post.title
    }
  end
end
