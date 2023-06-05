class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: [:edit, :update, :destroy]
  before_action :set_breadcrumbs, only: :index

  def index
    @announcements = Announcement.order(created_at: :desc)
  end

  def new
    @announcement = Announcement.new
  end

  def edit
  end

  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.user_id = current_user.id

    if @announcement.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.append("announcement-list", @announcement),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @announcement.update(announcement_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@announcement, @announcement),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @announcement.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@announcement),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.announcements.title_announcements"), announcements_path)
  end

  def announcement_params
    params.require(:announcement).permit(:title, :status, :published_at, :content)
  end
end
