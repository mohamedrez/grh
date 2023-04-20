class RequestPublisher
  include Wisper::Publisher

  def time_off_request_created(time_off_request)
    broadcast(:time_off_request_created, time_off_request)
  end
end
