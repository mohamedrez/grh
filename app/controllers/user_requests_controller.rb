class UserRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    user_id = params[:user_id]
    @user = User.find(user_id)
    @user_requests = UserRequest.where(user_id: user_id)
    authorize @user_requests
  end

  def update
    @user_request = UserRequest.find(params[:id])
    authorize @user_request
    @user_request.update(managed_by_id: current_user.id, state: params[:state])
    @requestable_id = @user_request.requestable_id
    redirect_to user_time_off_request_path(user_id: params[:user_id], id: @requestable_id)
  end
end
