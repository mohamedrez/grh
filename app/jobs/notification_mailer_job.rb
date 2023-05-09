class NotificationMailerJob < ApplicationJob
  queue_as :default

  def perform(object, subject, email)
    NotificationMailer.with(object: object).send_notification_email(subject, email).deliver_now
  end
end
