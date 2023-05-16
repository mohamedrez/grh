class ExperiencesController < ApplicationController
  def new
    @experience = Experience.new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @experience = Experience.new(experience_params)
    @experience.user_id = @user.id

    if @experience.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.append("experiences", partial: "experiences/experience", locals: {experience: @experience, user: @user}),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def experience_params
    params.require(:experience).permit(:job_title, :company_name, :employment_type, :start_date, :end_date, :city, :country, :work_description)
  end
end
