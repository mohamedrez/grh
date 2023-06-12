class UserRequestSubscriber
  def self.after_create(user_request)
    mailing_manager(user_request)
  end

  def self.mailing_manager(user_request)
    subject = "You have a new request"
    email = user_request.user.email
    NotificationMailerJob.perform_later(user_request, subject, email)
  end
end
