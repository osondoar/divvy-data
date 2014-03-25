class StatusService

  def all station_id
    Station.find(station_id).station_statuses.order(:id)
  end

end