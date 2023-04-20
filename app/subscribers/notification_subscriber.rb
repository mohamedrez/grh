class NotificationSubscriber
  def new_notification(event, subject)
    NotificationMailer.with(event: event, subject: subject).event_email.deliver_now
  end
end
