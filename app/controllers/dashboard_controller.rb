class DashboardController < ApplicationController
  def index
    @annoucements = Announcement.limit(3)
    @users = User.where.not(id: current_user.id).limit(5)
  end
end
