class TimeOffRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_locals, only: %i[show edit update destroy]

  def index
    user_id = params[:user_id]
    ids = UserRequest.where(
      user_id: user_id, requestable_type: "TimeOffRequest"
    ).pluck(:requestable_id)
    @time_off_requests = TimeOffRequest.where(id: ids)
    authorize @time_off_requests
    @user = User.find(user_id)
  end

  def show
    authorize @time_off_request
    @overlapping_requests = @time_off_request.overlapping_requests
    @user_request = @time_off_request.user_request
  end

  def new
    @time_off_request = TimeOffRequest.new
    @user = User.find(params[:user_id])
  end

  def edit
    authorize @time_off_request
  end

  def create
    @user = User.find(params[:user_id])
    @time_off_request = TimeOffRequest.new(time_off_request_params)
    @time_off_request.user_id = @user.id

    if @time_off_request.save
      flash.now[:notice] = t("time_Off_requests.time_Off_requests_created")
      render turbo_stream: [
        turbo_stream.prepend("time_off_requests", @time_off_request),
        turbo_stream.replace("notification_alert", partial: "layouts/alert"),
        turbo_stream.replace("new-time-off-request-form", partial: "form", locals: {user: @user, time_Off_request: TimeOffRequest.new})
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @time_off_request
    time_off_request_params[:user_id] = params[:user_id]

    if @time_off_request.update(time_off_request_params)
      flash.now[:notice] = t("time_Off_requests.time_Off_requests_updated")
      render turbo_stream: [
        turbo_stream.replace(@time_off_request, @time_off_request),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @time_off_request.destroy
    flash.now[:notice] = t("time_Off_requests.time_Off_requests_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@time_off_request),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_locals
    @time_off_request = TimeOffRequest.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def time_off_request_params
    params.require(:time_off_request).permit(:content, :start_date, :end_date, :user_id, :category)
  end
end
