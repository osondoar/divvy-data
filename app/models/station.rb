class Station < ActiveRecord::Base
	has_many :station_statuses
	class << self
		def from_api attrs
			new( 
				id: attrs[:id],
				total_docks: attrs[:totalDocks],
				name: attrs[:stationName],
				latitude: attrs[:latitude],
				longitude: attrs[:longitude],
				st_address: attrs[:stAddress1] << attrs[:stAddress2],
				location: attrs[:location]
			)
		end
	end
end
