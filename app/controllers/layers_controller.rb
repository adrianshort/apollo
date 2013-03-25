class LayersController < ApplicationController
  before_filter :require_login
  
  # GET /layers
  # GET /layers.json
  def index
    @layers = Layer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @layers }
    end
  end

  # GET /layers/1
  # GET /layers/1.json
  def show
    @layer = Layer.find(params[:id])
    @feed = Feed.new
    @feed.new_layer_id = @layer.id

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @layer }
    end
  end

  # GET /layers/new
  # GET /layers/new.json
  def new
    @layer = Layer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @layer }
    end
  end

  # GET /layers/1/edit
  def edit
    @layer = Layer.find(params[:id])
  end

  # POST /layers
  # POST /layers.json
  def create
    @layer = Layer.new(params[:layer])

    respond_to do |format|
      if @layer.save
        format.html { redirect_to @layer, notice: 'Layer was successfully created.' }
        format.json { render json: @layer, status: :created, location: @layer }
      else
        format.html { render action: "new" }
        format.json { render json: @layer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /layers/1
  # PUT /layers/1.json
  def update
    @layer = Layer.find(params[:id])

    respond_to do |format|
      if @layer.update_attributes(params[:layer])
        format.html { redirect_to @layer, notice: 'Layer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @layer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /layers/1
  # DELETE /layers/1.json
  def destroy
    @layer = Layer.find(params[:id])
    @layer.destroy

    respond_to do |format|
      format.html { redirect_to layers_url }
      format.json { head :no_content }
    end
  end

  # DELETE /layers/1/delete_feed
  # This only deletes the relation between the layer and the feed. The feed (and its posts) are retained.
  # Currently there's no way for the user to actually delete a feed completely.
  def delete_feed
    @layer = Layer.find(params[:id])
    @feed = Feed.find(params[:feed_id])
    @layer.feeds.delete(@feed)
    redirect_to @layer, notice: "Deleted feed #{@feed.title} from this layer"
  end
end
