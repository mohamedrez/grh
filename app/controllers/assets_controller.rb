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
      redirect_to user_assets_url(@user.id), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    asset_params[:user_id] = params[:user_id]
    if @asset.update(asset_params)
      redirect_to user_assets_url(params[:user_id]), notice: t("flash.successfully_created")
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
