class SubscriptionsController < ApplicationController
	def create
    Rails.logger.debug "Feed URL: %s" % params['subscription']['feed_url']

    if Feed.where(:feed_url => params['subscription']['feed_url']).size == 1 # ensure this test returns the values we expect
      Rails.logger.debug "Adding existing feed to a new layer"
      @feed = Feed.where(:feed_url => params['subscription']['feed_url']).first
      @layer = Layer.find(params['subscription']['layer_id']) # assumes that the specified layer exists
      # Attach the existing feed to the specified layer (making sure we only add each one once)
      # @feed.layers << @layer unless @feed.layers.include?(@layer)
    else
      # Create a new feed
      Rails.logger.debug "Creating a new feed"
      @feed = Feed.create(:feed_url => params[:subscription][:feed_url])
      @layer = Layer.find(params['subscription']['layer_id']) # assumes that the specified layer exists
      # @feed.layers << @layer unless @feed.layers.include?(@layer)
    end

		@subscription = Subscription.new(:feed => @feed, :layer => @layer)

		begin
	    respond_to do |format|
	      if @subscription.save
	        format.html { redirect_to @layer, notice: 'Feed added OK' }
	        format.json { render json: @feed, status: :created, location: @feed }
	      else
	        format.html { render action: "new" }
	        format.json { render json: @feed.errors, status: :unprocessable_entity }
	      end
	    end
	  rescue ActiveRecord::RecordNotUnique
   		redirect_to @layer, alert: 'That feed is already on this layer'
	  end
	end

  # GET /subscriptions/1/edit
  def edit
    @subscription = Subscription.find(params[:id])
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription.layer, notice: 'Subscription updated OK' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end


	def destroy
    @subscription = Subscription.find(params[:id])
    @layer = @subscription.layer
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to @layer, notice: 'Subscription deleted OK' }
      format.json { head :no_content }
    end
	end
end
