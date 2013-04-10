class Layer < ActiveRecord::Base
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions, :uniq => true

  attr_accessible :name

  # Unique name for Layar layer
  def layar_name
  	"apollo" + self.name.strip.downcase.gsub(/[^a-z0-9]/, '')
  end
end
