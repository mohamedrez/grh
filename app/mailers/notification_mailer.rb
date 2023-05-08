class NotificationMailer < ApplicationMailer
  def send_notification_email(subject, email)
    @object = params[:object]
    @subject = subject
    @email = email
    @link = user_time_request_url(user_id: @object.user.id, id: @object.requestable_id)
    mail(to: @email, subject: @subject)
  end
end
