class EventsController < ApplicationController
  def index
    events_response = []
    @events = Event.all
    @events.each do |event|
      events_response << {
        id: event.id, title: event.eventable_type, start: event.start_at,
        end: event.end_at,
        avatar: event.user.avatar_url_or_default,
        user: event.user.full_name, color: event.color
      }
    end
    render json: events_response
  end
end
