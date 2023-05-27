class DashboardController < ApplicationController
  def index
    @annoucements = Announcement.limit(3)
    @users = User.order(created_at: :desc).limit(5)
  end
end
