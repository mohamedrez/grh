class NotificationPublisher
  include Wisper::Publisher

  def new_notification(event, subject)
    broadcast(:new_notification, event, subject)
  end
end
