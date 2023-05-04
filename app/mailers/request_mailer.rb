class RequestMailer < ApplicationMailer
  def emailing_the_request
    @request = params[:request]
    @user = User.find(@request.user_id)
    @manger = User.find(@user.manager_id)
    @email_manager = @manger.email

    @request_message = request_message(@user)
    @request_url = request_url(@request)
    mail(to: @email_manager, subject: "A new request by #{@user.full_name}")
  end

  private

  def request_message(user)
    "We wanted to let you know that there is a new request by #{user.full_name} waiting for you."
  end

  def request_url(request)
    user_time_request_url(user_id: request.user.id, id: request.requestable_id)
  end
end
