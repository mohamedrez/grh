class AssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_locals, only: %i[edit update]

  def index
    @user = User.find(params[:user_id])
    @assets = Asset.where(user_id: @user.id)
  end

  def new
    @asset = Asset.new
    @user = User.find(params[:user_id])
  end

  def edit
  end

  def create
    @user = User.find(params[:user_id])
    @asset = Asset.new(asset_params)
    @asset.user_id = @user.id

    if @asset.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.prepend("assets-list", @asset),
        turbo_stream.replace("modal", partial: "create_button"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    asset_params[:user_id] = params[:user_id]
    if @asset.update(asset_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@asset, @asset),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_locals
    @asset = Asset.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def asset_params
    params.require(:asset).permit(:category, :description, :serial, :date_assigned, :date_returned)
  end
end
