class EventNotification < Noticed::Base
  # Add your delivery methods
  deliver_by :database

  # Add required params
  param :event

  # Define helper methods to make rendering easier.
  def message
    event = params[:event]
    (event.eventable_type == "TimeOffRequest") ? "A new Time Off Request by #{event.user.email}" : "A new Event by #{event.user.email}"
  end

  def url
    event = params[:event]
    (event.eventable_type == "TimeOffRequest") ? user_time_off_request_path(user_id: event.user.id, id: event.eventable_id) : root_path
  end
end
