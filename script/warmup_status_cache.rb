abort "rails runner script/warmup_status_cache.rb :status_count" if ARGV.count < 1
Station.all.each do |station|
  p "Station #{station.id}"
  statuses = StationStatus.where(station_id: station.id).order(id: :desc).limit(ARGV[0].to_i)
  compressed_statuses = Snappy.deflate(statuses.to_json)
  $redis.set( "status_#{station.id}", compressed_statuses)
end