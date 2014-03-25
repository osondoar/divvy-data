response = HTTParty.get('http://divvybikes.com/stations/json')
stations = JSON.parse(response.body).symbolize_keys!

Station.destroy_all

stations = stations[:stationBeanList]
stations.each do |station|
	station = Station.from_api station.symbolize_keys
	station.save
end

p "Created #{stations.count} stations"
