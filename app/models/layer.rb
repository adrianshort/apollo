class Layer < ActiveRecord::Base
  attr_accessible :name
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions, :uniq => true
end
