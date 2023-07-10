class EducationsController < ApplicationController
  before_action :set_user, only: %i[new edit create update]
  before_action :set_education, only: %i[edit update destroy]

  def new
    @education = Education.new
  end

  def edit
  end

  def create
    @education = Education.new(education_params)
    @education.user_id = @user.id

    if @education.save
      flash.now[:notice] = t("flash.successfully_created")
      render turbo_stream: [
        turbo_stream.remove("no-academic-backgrounds"),
        turbo_stream.append("education-list", partial: "educations/education", locals: {education: @education, user: @user}),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    education_params[:user_id] = params[:user_id]
    if @education.update(education_params)
      flash.now[:notice] = t("flash.successfully_updated")
      render turbo_stream: [
        turbo_stream.replace(@education, partial: "educations/education", locals: {education: @education, user: @user}),
        turbo_stream.replace("right", partial: "shared/right"),
        turbo_stream.replace("notification_alert", partial: "layouts/alert")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @education.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@education),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_education
    @education = Education.find(params[:id])
  end

  def education_params
    params.require(:education).permit(:school, :country, :city, :education_level, :study_field, :start_date, :end_date, :still_on_this_course)
  end
end
