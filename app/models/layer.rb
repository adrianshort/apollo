class Layer < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :feeds

  # Unique name for Layar layer
  def layar_name
  	"apollo" + self.name.strip.downcase.gsub(/[^a-z0-9]/, '')
  end
end
