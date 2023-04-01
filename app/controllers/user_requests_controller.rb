class UserRequestsController < ApplicationController
  def index
    @user_requests = UserRequest.all
  end
end
