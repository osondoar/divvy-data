Station.all.each do |station|
  p "Station #{station.id}"
  statuses = StationStatus.where(station_id: station.id).order(id: :desc).limit(50000)
  compressed_statuses = Snappy.deflate(statuses.to_json)
  $redis.set( "status_#{station.id}", compressed_statuses)
end