class StationStatus < ActiveRecord::Base
	belongs_to :station

	class << self
		def from_api attrs, timestamp
			new( 
				station_id: attrs[:id],
				available_bikes: attrs[:availableBikes],
				created_at: timestamp
			)
		end
	end
end
