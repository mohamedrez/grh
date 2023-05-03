class AnnouncementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_announcement, only: [:edit, :update, :show, :destroy]

  def index
    @announcements = Announcement.all
  end

  def show
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
      redirect_to announcements_path, notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @announcement.update(announcement_params)
      redirect_to announcements_path, notice: t("flash.successfully_updated")
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @announcement.destroy
    redirect_to announcements_path
  end

  private

  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  def announcement_params
    params.require(:announcement).permit(:title, :status, :published_at, :content)
  end
end
