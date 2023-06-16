class NotificationMailerJob < ApplicationJob
  queue_as :default

  def perform(object, subject:, email:, link_text:, link_url:, description:, title:)
    NotificationMailer.with(object: object)
      .send_notification_email(
        subject: subject,
        email: email,
        link_text: link_text,
        link_url: link_url,
        description: description,
        title: title
      )
      .deliver_now
  end
end
