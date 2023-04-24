class NotificationSubscriber
  def new_notification(event)
    NotificationMailer.with(event: event).notification_email.deliver_now
  end
end
