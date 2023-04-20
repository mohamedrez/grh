class NotificationMailer < ApplicationMailer
  def event_email
    @event = params[:event]
    @user = @event.user
    @subject = params[:subject]
    mail(to: @user.email, subject: @subject)
  end
end
