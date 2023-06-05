class UserRequestsController < ApplicationController
  before_action :set_breadcrumbs, only: :index
  def index
    user_id = params[:user_id]
    @user = User.find(user_id)
    @user_requests = UserRequest.where(user_id: user_id)
  end

  def update
    @user_request = UserRequest.find(params[:id])
    @user_request.update(managed_by_id: current_user.id, state: params[:state])
    @requestable_id = @user_request.requestable_id
    redirect_to user_time_request_path(user_id: params[:user_id], id: @requestable_id)
  end

  private

  def set_breadcrumbs
    @user = User.find(params[:user_id])
    add_breadcrumb(@user.full_name, @user)
    add_breadcrumb(t("views.user_requests.title_user_request"), user_user_requests_path(@user))
  end
end
