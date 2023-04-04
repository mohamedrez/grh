class UserRequestsController < ApplicationController
  def index
    user_id = params[:user_id]
    @user_requests = UserRequest.where(user_id: user_id)
  end
end
