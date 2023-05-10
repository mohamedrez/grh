class DashboardController < ApplicationController
  def index
    @annoucements = Announcement.limit(3)
  end
end
