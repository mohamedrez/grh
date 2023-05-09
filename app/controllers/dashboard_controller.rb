class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @annoucements = Announcement.limit(3)
  end
end
