class PostsController < ApplicationController
  def near
    @posts = Post.near(params[:lat].to_f, params[:lng].to_f, params[:radius].to_f)

    respond_to do |format|
      format.html # near.html.erb
      format.json { render json: @posts }
    end
  end
end
