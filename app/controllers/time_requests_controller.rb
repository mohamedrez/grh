class TimeRequestsController < ApplicationController
  before_action :set_locals, only: %i[show edit update destroy]

  def index
    user_id = params[:user_id]
    ids = UserRequest.where(
      user_id: user_id, requestable_type: "TimeRequest"
    ).pluck(:requestable_id)
    @time_requests = TimeRequest.where(id: ids)
    authorize @time_requests
    @user = User.find(user_id)
  end

  def show
    authorize @time_request
    @overlapping_requests = @time_request.overlapping_requests
    @user_request = @time_request.user_request
  end

  def new
    @time_request = TimeRequest.new
    @user = User.find(params[:user_id])
  end

  def edit
    authorize @time_request
  end

  def create
    @user = User.find(params[:user_id])
    @time_request = TimeRequest.new(time_request_params)
    @time_request.user_id = @user.id

    if @time_request.save
      redirect_to user_time_request_url(@user, @time_request), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @time_request
    time_request_params[:user_id] = params[:user_id]

    if @time_request.update(time_request_params)
      redirect_to user_time_request_url(@user, @time_request), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @time_request.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@time_request),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_locals
    @time_request = TimeRequest.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def time_request_params
    params.require(:time_request).permit(:content, :start_date, :end_date, :user_id, :category)
  end
end
