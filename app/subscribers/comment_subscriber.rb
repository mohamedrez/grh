class CommentSubscriber
  URL_HELPERS = Rails.application.routes.url_helpers

  def self.after_create(comment)
    notify_thread(comment)

    # Notify the user if he is not the author of the comment
    if comment.author_id != comment.commentable.user_id &&
        comment.one_comment?
      notify_comment(comment, comment.commentable.user.email)
    end

    # Notify the manager if he is not the author of the comment
    if comment.author_id != comment.commentable.user&.manager_id &&
        comment.commentable.user.manager&.email &&
        comment.one_comment?
      notify_comment(comment, comment.commentable.user.manager.email)
    end
  end

  def self.notify_thread(comment)
    comments_to_notify = comment.same_thread_comments
      .where.not(author_id: comment.author_id)
    emails = User.where(
      id: comments_to_notify.pluck(:author_id)
    ).pluck(:email).uniq
    emails.each do |email|
      notify_comment(comment, email)
    end
  end

  def self.link_url(comment)
    case comment.commentable.requestable_type
    when "Expense"
      URL_HELPERS.user_expense_url(user_id: comment.commentable.user.id, id: comment.commentable.requestable_id)
    when "TimeRequest"
      URL_HELPERS.user_time_request_url(user_id: comment.commentable.user.id, id: comment.commentable.requestable_id)
    end
  end

  def self.notify_comment(comment, email = nil)
    subject = title = "Nouveau commentaire"
    email ||= comment.author.email
    link_text = "Voir le commentaire"
    description = "Un nouveau commentaire a été ajouté par #{comment.author.full_name}"
    NotificationMailerJob.perform_later(
      comment,
      subject: subject,
      email: email,
      link_text: link_text,
      title: title,
      description: description,
      link_url: link_url(comment)
    )
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
