class ExperiencesController < ApplicationController
  before_action :set_user, only: %i[new edit create update]
  before_action :set_experience, only: %i[edit update destroy]

  def new
    @experience = Experience.new
  end

  def edit
  end

  def create
    @experience = Experience.new(experience_params)
    @experience.user_id = @user.id

    if @experience.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.remove("no-experiences"),
        turbo_stream.append("experience-list", partial: "experiences/experience", locals: {experience: @experience, user: @user}),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    experience_params[:user_id] = params[:user_id]
    if @experience.update(experience_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@experience, partial: "experiences/experience", locals: {experience: @experience, user: @user}),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @experience.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@experience),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_experience
    @experience = Experience.find(params[:id])
  end

  def experience_params
    params.require(:experience).permit(:job_title, :company_name, :employment_type, :start_date, :end_date, :city, :country, :work_description)
  end
end
