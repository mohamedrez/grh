class UserRequestSubscriber
  URL_HELPERS = Rails.application.routes.url_helpers

  def self.after_create(user_request)
    mailing_manager(user_request)
  end

  def self.after_update(user_request)
    mailing_owner(user_request)
  end

  def self.mailing_manager(user_request)
    return unless user_request.user.manager_id

    subject = title = "Vous avez une nouvelle demande"
    email = user_request.user.manager&.email
    link_url = URL_HELPERS.user_time_request_url(user_id: user_request.user.id, id: user_request.requestable_id)
    link_text = "Voir la demande"
    description = "L'employé #{user_request.user.full_name} vient de soummettre"
    description += "une nouvelle demande de type #{user_request.requestable_type}"
    NotificationMailerJob.perform_later(
      user_request,
      subject: subject,
      email: email,
      link_text: link_text,
      title: title,
      description: description,
      link_url: link_url
    )
  end

  def self.mailing_owner(user_request)
    subject = title = "Votre demande vient d'être mis à jour"
    email = user_request.user.email
    link_url = URL_HELPERS.user_time_request_url(user_id: user_request.user.id, id: user_request.requestable_id)
    link_text = "Voir la demande"
    description = "l'état #{user_request.state} par #{user_request.managed_by.full_name} "
    NotificationMailerJob.perform_later(
      user_request,
      subject: subject,
      email: email,
      link_text: link_text,
      title: title,
      description: description,
      link_url: link_url
    )
  end
end
