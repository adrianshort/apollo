class CreateLayers < ActiveRecord::Migration
  def change
    create_table :layers do |t|
      t.string :name
      t.timestamps
    end

    create_table :feeds_layers, :id => false do |t|
    	t.integer :feed_id
    	t.integer :layer_id
   	end

   	add_index :feeds_layers, [ :feed_id, :layer_id ]
  end
end
