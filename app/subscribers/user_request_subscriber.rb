class UserRequestSubscriber
  URL_HELPERS = Rails.application.routes.url_helpers

  def after_create(user_request)
    notify_manager(user_request)
  end

  def notify_hr_site_manager(user_request)
    notifying_validator(user_request, "hr_site_manager")
  end

  def notify_accountant_site_manager(user_request)
    notifying_validator(user_request, "accountant_site_manager")
  end

  def notify_holding_treasury_manager(user_request)
    notifying_validator(user_request, "holding_treasury_manager")
  end

  def notify_owner(user_request)
    sending_email(
      user_request,
      user_request.user.email,
      I18n.t("mailing.title.request_updated"),
      I18n.t("mailing.link_text.see_request"),
      I18n.t("mailing.description.state_been_updated", type: I18n.t("views.user_requests.requestable.#{user_request.requestable_type}"))
    )
  end

  private

  def notify_manager(user_request)
    return unless user_request.user.manager_id

    sending_email(
      user_request,
      user_request.user.manager&.email,
      I18n.t("mailing.title.new_request"),
      I18n.t("mailing.link_text.see_request"),
      I18n.t("mailing.description.employee_submitted_new_request", username: user_request.user.full_name, type: I18n.t("views.user_requests.requestable.#{user_request.requestable_type}"))
    )
  end

  def notifying_validator(user_request, role_name)
    site = user_request.user.site
    return unless site

    role = site.roles.find_by(name: role_name)
    return unless role

    sending_email(
      user_request,
      role.user.email,
      I18n.t("mailing.title.request_to_review"),
      I18n.t("mailing.link_text.review_request"),
      I18n.t("mailing.description.request_requires_review", type: I18n.t("views.user_requests.requestable.#{user_request.requestable_type}"), username: user_request.user.full_name)
    )
  end

  def sending_email(user_request, email, title, link_text, description)
    subject = title
    NotificationMailerJob.perform_later(
      user_request,
      subject: subject,
      email: email,
      link_text: link_text,
      title: title,
      description: description,
      link_url: link_url(user_request)
    )
  end

  def link_url(user_request)
    case user_request.requestable_type
    when "Expense"
      URL_HELPERS.user_expense_url(user_id: user_request.user.id, id: user_request.requestable_id)
    when "TimeRequest"
      URL_HELPERS.user_time_request_url(user_id: user_request.user.id, id: user_request.requestable_id)
    when "MissionOrder"
      URL_HELPERS.user_mission_order_url(user_id: user_request.user.id, id: user_request.requestable_id)
    end
  end
end
