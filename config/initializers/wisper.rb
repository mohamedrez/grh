require_relative "../../app/publishers/notification_publisher"
require_relative "../../app/subscribers/notification_subscriber"

# registering the NotificationSubscriber class with the NotificationPublisher class
# so that it will receive the events.
NotificationPublisher.subscribe(NotificationSubscriber.new)
