require 'daemons'

class DivvyStatusUpdater

  def run
    log_name = Rails.root.join('log','fetch_location_data.log')
    daemon_logger = Logger.new(log_name, Logger::INFO)
    # This is fucking with the rails logger, it's logging everything in production
    Rails.logger = ActiveRecord::Base.logger = daemon_logger

    loop do
      begin
        response = HTTParty.get('http://divvybikes.com/stations/json')
        stations_response = JSON.parse(response.body).symbolize_keys!
        stations = stations_response[:stationBeanList]
        statuses_to_insert = []
        stations.each do |station|
          station_status =  StationStatus.from_api station.symbolize_keys, stations_response[:executionTime]
          statuses_to_insert << "('#{station_status.station_id}', '#{station_status.available_bikes}', '#{station_status.created_at}')"

          # add status to cache
          update_cache station_status
        end
        
        sql = "INSERT INTO station_statuses (station_id, available_bikes, created_at) VALUES #{statuses_to_insert.join(", ")}"
        ActiveRecord::Base.connection.execute(sql)

        daemon_logger.info "Divvy time: #{stations_response[:executionTime]}. #{stations.count} statuses saved"
      rescue StandardError => e
        daemon_logger.error e.message
      end
      sleep 60
    end
  end

  def update_cache status
    compressed_statuses= $redis.get("status_#{status.station_id}")
    statuses_json = compressed_statuses ? Snappy.inflate(compressed_statuses) : [].to_json
    status_json = status.to_json
    status_json << ',' if compressed_statuses
    statuses_json.insert(1, status_json)
    $redis.set("status_#{status.station_id}", Snappy.deflate(statuses_json))
  end

end

Daemons.run_proc("update_divvy_status") do
  DivvyStatusUpdater.new.run
end
