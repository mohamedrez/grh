class RequestMailer < ApplicationMailer
  def mailing
    @request = params[:request]
    @request_message = params[:request_message]
    @request_url = request_url(@request)

    @employee = User.find(@request.user_id)
    @manager = User.find(@employee.manager_id)

    if @request.pending?
      @email = @manager.email
      mail(to: @email, subject: "A new request by #{@employee.full_name}")
    else
      @email = @employee.email
      mail(to: @email, subject: "Your request has been reviewd by #{@manager.full_name}")
    end
  end

  private

  def request_url(request)
    user_time_request_url(user_id: request.user.id, id: request.requestable_id)
  end
end
