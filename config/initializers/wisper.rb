require_relative "../../app/publishers/request_publisher"
require_relative "../../app/subscribers/request_subscriber"

# registering the RequestSubscriber class with the RequestPublisher class
# so that it will receive the events.
RequestPublisher.subscribe(RequestSubscriber.new)
