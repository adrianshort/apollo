class FeedsController < ApplicationController
  before_filter :require_login
    
  # GET /feeds
  # GET /feeds.json
  def index
    @feed = Feed.new
    @feeds = Feed.all :order => :title
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])
    @posts = @feed.posts.order("published desc").paginate(:page => params[:page], :per_page => 20)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/new
  # GET /feeds/new.json
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # Feeds are created through the Subscriptions controller

  # PUT /feeds/1
  # PUT /feeds/1.json
  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.html { redirect_to @feed, notice: 'Feed updated OK' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # Feeds are never deleted. They're always retained in the DB.

  def fetch
    @feed = Feed.find(params[:id])
    @feed.fetch
    redirect_to :back, notice: 'Feed fetched OK'
  end
  
  def fetch_all
    Feed.fetch_all
    redirect_to :back, notice: 'All feeds fetched OK'
  end
end
