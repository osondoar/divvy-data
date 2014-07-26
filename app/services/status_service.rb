require 'snappy'
class StatusService

  def all station_id
    cached_stations = $redis.get status_cache_key(station_id)
    if cached_stations 
      stations = Snappy.inflate(cached_stations)
    else
      stations = Station.find(station_id).station_statuses.order(id: :desc).limit(5000)
      compressed_stations = Snappy.deflate(stations.to_json)
      $redis.set(status_cache_key(station_id), compressed_stations)
    end
    return stations
  end

  def status_cache_key station_id
    "status_#{station_id}"
  end
end
