require 'daemons'

Daemons.run_proc("update_divvy_status") do

  log_name = Rails.root.join('log','fetch_location_data.log')
  daemon_logger = Logger.new(log_name, Logger::INFO)
  # This is fucking with the rails logger, it's logging everything in production
  Rails.logger = ActiveRecord::Base.logger = daemon_logger

  loop do
    begin
      response = HTTParty.get('http://divvybikes.com/stations/json')
      stations_response = JSON.parse(response.body).symbolize_keys!
      stations = stations_response[:stationBeanList]
      stations.each do |station|
        station_status = StationStatus.from_api station.symbolize_keys, stations_response[:executionTime]
        previous_status = StationStatus.where(station_id: station_status.station_id).last
        station_status.save

        # add status to cache
        compressed_statuses= $redis.get("status_#{station_status.station_id}")
        statuses = compressed_statuses.nil? ? [] : JSON.parse(Snappy.inflate(compressed_statuses))
        statuses << station_status
        compressed_statuses = Snappy.deflate(statuses.to_json)
        $redis.set( "status_#{station_status.station_id}", compressed_statuses)
      end

      daemon_logger.info "Divvy time: #{stations_response[:executionTime]}. #{stations.count} statuses saved"
    rescue StandardError => e
      daemon_logger.error e.message
    end
    sleep 60
  end
end