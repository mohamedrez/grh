require_relative "../../app/publishers/event_publisher"
require_relative "../../app/subscribers/event_subscriber"

# registering the EventSubscriber class with the EventPublisher class
# so that it will receive the events.
EventPublisher.subscribe(EventSubscriber.new)
