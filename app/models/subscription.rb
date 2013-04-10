class Subscription < ActiveRecord::Base
  attr_accessor :feed_url
  belongs_to :feed
  belongs_to :layer
end
