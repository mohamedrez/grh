class NotificationMailer < ApplicationMailer
  def send_notification_email(subject:, email:, link_url:, link_text:, description:, title:)
    @object = params[:object]
    @subject = subject
    @email = email
    @link_url = link_url
    @link_text = link_text
    @description = description
    @title = title
    mail(to: @email, subject: @subject)
  end
end
