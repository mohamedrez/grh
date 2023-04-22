# To deliver this notification:
#
# EventNotification.with(post: @post).deliver_later(current_user)
# EventNotification.with(post: @post).deliver(current_user)

class EventNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    event = params[:event]
    user = event.user
    "A new #{event.eventable_type} by #{user.email}"
  end

  def url
    root_path
  end
end
