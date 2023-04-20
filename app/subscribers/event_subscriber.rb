class EventSubscriber
  def event_created(event)
    NotificationMailer.with(event: event).event_email.deliver_now
  end
end
