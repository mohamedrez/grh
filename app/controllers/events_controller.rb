class EventsController < ApplicationController
  def index
    @events = []
    @events += holidays
    @events += time_requests

    render json: @events
  end

  private

  def time_requests
    @time_requests ||= TimeRequest.all.includes(:user_request).includes(user_request: :user)
    if params["service"].present?
      @time_requests = @time_requests.where(user_requests: {users: {service: params[:service]}})
    end
    if params["site"].present?
      @time_requests = @time_requests.where(user_requests: {users: {site_id: params[:site]}})
    end
    @time_requests.map do |time_request|
      {
        id: time_request.id,
        title: time_request.user.full_name,
        start: time_request.start_date,
        end: time_request.end_date,
        avatar: time_request.user.avatar_url_or_default,
        color: time_request.color
      }
    end
  end

  def holidays
    @holidays ||= Holiday.all
    @holidays.map do |holiday|
      {
        id: holiday.id,
        title: holiday.name,
        start: holiday.start_date,
        end: holiday.end_date,
        color: "green"
      }
    end
  end
end
