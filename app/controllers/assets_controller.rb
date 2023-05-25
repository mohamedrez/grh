class AssetsController < ApplicationController
  before_action :set_user
  before_action :set_asset, only: %i[show edit update destroy]

  def index
    @assets = Asset.where(user_id: @user.id)
  end

  def show
  end

  def new
    @asset = Asset.new
  end

  def edit
  end

  def create
    @asset = Asset.new(asset_params)
    @asset.user_id = @user.id

    if @asset.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.prepend("asset-list", @asset),
        turbo_stream.replace("right", partial: "shared/right"),
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
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @asset.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@asset),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_asset
    @asset = Asset.find(params[:id])
  end

  def asset_params
    params.require(:asset).permit(:category, :description, :serial, :date_assigned, :date_returned)
  end
end
