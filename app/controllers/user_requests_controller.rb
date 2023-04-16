class UserRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    user_id = params[:user_id]
    @user_requests = UserRequest.where(user_id: user_id)
  end

  def update
    @user_request = UserRequest.find(params[:id])
    if params[:state] == "approved"
      @user_request.update(managed_by_id: params[:managed_by_id], state: :approved)
    elsif params[:state] == "rejected"
      @user_request.update(managed_by_id: params[:managed_by_id], state: :rejected)
    end
    @requestable_id = @user_request.requestable_id
    redirect_to user_time_off_request_path(user_id: params[:user_id], id: @requestable_id)
  end
end
