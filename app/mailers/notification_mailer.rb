class NotificationMailer < ApplicationMailer
  def notification_email
    @event = params[:event]
    @eventable_message = eventable_message(@event)
    @eventable_url = eventable_url(@event)
    @user = @event.user
    mail(to: @user.email, subject: @eventable_message)
  end

  private

  def eventable_message(event)
    (event.eventable_type == "TimeOffRequest") ? "A new Time Off Request by #{event.user.email}" : "A new Event by #{event.user.email}"
  end

  def eventable_url(event)
    (event.eventable_type == "TimeOffRequest") ? user_time_off_request_url(user_id: event.user.id, id: event.eventable_id) : root_url
  end
end
