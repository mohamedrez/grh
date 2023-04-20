class NotificationMailer < ApplicationMailer
  def event_email
    @event = params[:event]
    @user = @event.user
    @subject = (@event.eventable_type == "TimeOffRequest") ? "A time off request was successfully created" : "New event"
    mail(to: @user.email, subject: @subject)
  end
end
