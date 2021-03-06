class PostsController < ApplicationController
  include PostsHelper
  
  def near
    @posts = Post.near(params[:lat].to_f, params[:lon].to_f, params[:radius].to_f, params[:layer_id])

#     ErrorLog.create(
#       :ts => Time.now,
#       :params => params,
#       :pois_returned => @posts.size
#     )
    @layer = Layer.find(params[:layer_id])

    layar_response = {
      :layer =>         @layer.layar_name,
      :hotspots =>      @posts.collect { |p| post_to_poi(p, Subscription.where(:feed_id => p.feed_id, :layer_id => @layer.id).first) },
      :errorCode =>     0, # OK
      :errorString =>   "OK",
      :radius =>        params[:radius].to_f
    }

    respond_to do |format|
      format.html # near.html.erb
      format.json { render json: @posts }
      format.layar { render json: layar_response }
    end
  end
end
