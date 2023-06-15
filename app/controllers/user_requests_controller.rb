class UserRequestsController < ApplicationController
  before_action :set_breadcrumbs, only: :index

  def index
    user_id = params[:user_id]
    if user_id
      @user = User.find(user_id)
      @user_requests = UserRequest.where(user_id: user_id)
    else
      @user_requests = authorized_scope(UserRequest.all)
    end
  end

  def update
    @user_request = UserRequest.find(params[:id])
    @user_request.update(managed_by_id: current_user.id, state: params[:state])

    redirect_to polymorphic_url([@user_request.user, @user_request.requestable])
  end

  private

  def set_breadcrumbs
    add_breadcrumb(t("views.layouts.main.requests"))
  end
end
