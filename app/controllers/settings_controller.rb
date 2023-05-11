class SettingsController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_settings_path(user_id: @user.id), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
end
