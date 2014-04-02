daemon_logger = Logger.new(Rails.root.join('log','fetch_location_data.log'))
# This is fucking with the rails logger, it's loggin everything in production
#Rails.logger = ActiveRecord::Base.logger = Logger.new(Rails.root.join("log","#{Rails.env}.log"))

loop do
  begin
  	response = HTTParty.get('http://divvybikes.com/stations/json')
  	stations_response = JSON.parse(response.body).symbolize_keys!

  	stations = stations_response[:stationBeanList]
  	stations.each do |station|
  		station = StationStatus.from_api station.symbolize_keys, stations_response[:executionTime]
  		station.save
  	end

  	daemon_logger.info "Divvy time: #{stations_response[:executionTime]}. #{stations.count} statuses saved"
  rescue StandardError => e
    daemon_logger.error e.message
  end
	sleep 60
end
