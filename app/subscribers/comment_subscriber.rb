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
        comment.commentable_type == "UserRequest" &&
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
    when "MissionOrder"
      URL_HELPERS.user_mission_order_url(user_id: comment.commentable.user.id, id: comment.commentable.requestable_id)
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
end
