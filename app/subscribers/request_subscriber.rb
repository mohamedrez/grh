class RequestSubscriber
  def time_off_request_created(time_off_request)
    # a temporary one
    time_off_request.user_request.user.send_reset_password_instructions
  end
end
