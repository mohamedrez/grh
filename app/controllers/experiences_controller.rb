class ExperiencesController < ApplicationController
  before_action :authenticate_user!

  def new
    @experience = Experience.new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @experience = Experience.new(experience_params)
    @experience.user_id = @user.id

    if @experience.save
      redirect_to user_url(@experience.user), notice: t("experiences.experience_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def experience_params
    params.require(:experience).permit(:job_title, :company_name, :employment_type, :start_date, :end_date, :city, :country, :work_description)
  end
end
