class EventPublisher
  include Wisper::Publisher

  def event_created(event)
    broadcast(:event_created, event)
  end
end
