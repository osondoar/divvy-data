class StatusesController < ApplicationController
  before_filter :deps

  def show
    current_status = Station.find(params[:station_id]).station_statuses.last
    render json: current_status
  end

  def search
    all = @status_service.all params[:station_id]
    render json: all
  end

  private
  def deps
    @status_service = StatusService.new
  end

end
