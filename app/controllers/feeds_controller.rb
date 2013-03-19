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

  # POST /feeds
  # POST /feeds.json
  def create
    

    Rails.logger.debug "Feed URL: %s" % params['feed']['feed_url']

    if Feed.where(:feed_url => params['feed']['feed_url']).size == 1 # ensure this test returns the values we expect
      Rails.logger.debug "Adding existing feed to a new layer"
      @feed = Feed.where(:feed_url => params['feed']['feed_url']).first
      @layer = Layer.find(params['feed']['new_layer_id']) # assumes that the specified layer exists
      # Attach the existing feed to the specified layer (making sure we only add each one once)
      @feed.layers << @layer unless @feed.layers.include?(@layer)
    else
      # Create a new feed
      Rails.logger.debug "Creating a new feed"
      @feed = Feed.new(params[:feed])
      @layer = Layer.find(params['feed']['new_layer_id']) # assumes that the specified layer exists
      @feed.layers << @layer unless @feed.layers.include?(@layer)
    end

    respond_to do |format|
      if @feed.save
        format.html { redirect_to @layer, notice: 'Feed added OK' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

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

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed deleted OK' }
      format.json { head :no_content }
    end
  end
  
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
