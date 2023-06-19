class ErrorsController < ApplicationController
  # https://dev.to/ayushn21/custom-error-pages-in-rails-4i43

  def show
    @exception = request.env["action_dispatch.exception"]
    @status_code = @exception.try(:status_code) ||
      ActionDispatch::ExceptionWrapper.new(
        request.env, @exception
      ).status_code

    # TODO add request_id
    view_for_code(@status_code, @exception.message)
  end

  private

  def view_for_code(code, message = nil)
    @error_message = message_by_status(message).fetch(code)
    flash.now.alert = @error_message

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("notification_alert", partial: "layouts/alert") }
      format.html { render "show" }
    end
  end

  def message_by_status(message = nil)
    {
      403 => "Forbidden",
      401 => "Unauthorized",
      400 => "Error: #{message}",
      404 => "Ressource not found",
      500 => "There was an error on the server please contact the support"
    }
  end
end
