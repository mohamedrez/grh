class EventsController < ApplicationController
  def index
    @events = []
    @events += holidays
    @events += time_requests
    @events += mission_orders
    @events += expenses

    render json: @events
  end

  def time_requests
    fetch_events(TimeRequest) do |time_request|
      {
        id: time_request.id,
        type: "Time request",
        title: time_request.user.full_name,
        start: time_request.start_date,
        end: time_request.end_date,
        avatar: time_request.user.avatar_url_or_default,
        color: time_request.color
      }
    end
  end

  def mission_orders
    fetch_events(MissionOrder) do |mission_order|
      {
        id: mission_order.id,
        type: "Mission order",
        title: mission_order.user.full_name,
        start: mission_order.start_date,
        end: mission_order.end_date,
        avatar: mission_order.user.avatar_url_or_default
      }
    end
  end

  def expenses
    fetch_events(Expense) do |expense|
      {
        id: expense.id,
        type: "Expense",
        title: expense.user.full_name,
        date: expense.date,
        avatar: expense.user.avatar_url_or_default
      }
    end
  end

  private

  def fetch_events(model_class)
    events = model_class.all.includes(:user_request).includes(user_request: :user)
    if params["service"].present?
      events = events.where(user_requests: {users: {service: params[:service]}})
    end
    if params["site"].present?
      events = events.where(user_requests: {users: {site_id: params[:site]}})
    end
    events.map { |event| yield event }
  end

  def holidays
    @holidays ||= Holiday.all
    @holidays.map do |holiday|
      {
        id: holiday.id,
        title: holiday.name,
        start: holiday.start_date,
        end: holiday.end_date,
        color: "#D3AC2B"
      }
    end
  end
end
