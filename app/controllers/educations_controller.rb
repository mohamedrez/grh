class EducationsController < ApplicationController
  def new
    @education = Education.new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @education = Education.new(education_params)
    @education.user_id = @user.id

    if @education.save
      redirect_to user_url(@education.user), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def education_params
    params.require(:education).permit(:school, :country, :city, :education_level, :study_field, :start_date, :end_date, :still_on_this_course)
  end
end
