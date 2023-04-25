class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[edit update]

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_profile_path(user_id: @user.id), notice: t("flash.profiles_controller.account_been_updated")
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def user_params
    params.require(:user).permit(:email, :username, :learning_goal, :avatar)
  end
end
