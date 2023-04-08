class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.search(params)
  end

  def show
  end

  def edit
    @address = @user.address || @user.build_address
    @experiences = @user.experiences
    @educations = @user.educations
  end

  def update
    respond_to do |format|
      @user.create_address!(user_params[:address_attributes]) unless @user.address
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: t("flash.profiles_controller.account_been_updated") }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :about,
      :birthdate,
      :start_date,
      :end_date,
      :gender,
      :marital_status,
      :phone,
      :job_title,
      address_attributes:
      [
        :id,
        :street,
        :country,
        :city,
        :zipcode
      ]
    )
  end
end
