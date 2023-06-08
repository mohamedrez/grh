class ErrorsController < ApplicationController
  # https://dev.to/ayushn21/custom-error-pages-in-rails-4i43

  def show
    @exception = request.env["action_dispatch.exception"]
    @status_code = @exception.try(:status_code) ||
      ActionDispatch::ExceptionWrapper.new(
        request.env, @exception
      ).status_code

    # TODO add request_id
    view_for_code(@status_code)
  end

  private

  def view_for_code(code)
    message_by_status.fetch(code)
    flash.now.alert = message_by_status.fetch(code)
    render turbo_stream: [
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  def message_by_status
    {
      403 => "Forbidden",
      401 => "Unauthorized",
      404 => "Ressource not found",
      500 => "There was an error on the server please contact the support"
    }
  end
end
