class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
    	t.string :name
    	t.integer :total_docks
    	t.float  :latitude
    	t.float  :longitude
    	t.string  :st_address
    	t.string  :location
      t.timestamps
    end
  end
end
