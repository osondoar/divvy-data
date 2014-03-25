class CreateStationStatuses < ActiveRecord::Migration
  def change
    create_table :station_statuses do |t|
    	t.references :station
     	t.integer :available_bikes
      
     	t.datetime :created_at
    end
  end
end
