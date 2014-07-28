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

	def to_json
		{
			station_id: station_id,
			available_bikes: available_bikes,
			created_at: created_at
		}.to_json
	end
end
