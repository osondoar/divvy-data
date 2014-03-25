class FetchStationDataDaemon
	class << self
		def run
			Daemons.run 'script/fetch_data.rb'
		end

	end
end
