class EducationsController < ApplicationController
<<<<<<< HEAD
  before_action :set_education, only: %i[edit update]
=======
  before_action :set_education, only: %i[show edit update destroy]
>>>>>>> 909aa4c (fixed  styles)

  def new
    @education = Education.new
  end

  def edit
  end

  def create
    @education = Education.new(education_params)

    respond_to do |format|
      if @education.save
        format.html { redirect_to edit_user_url(@education.user), notice: t("educations.education_created") }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @education.update(education_params)
        format.html { redirect_to edit_user_url(@education.user), notice: t("educations.education_updated") }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_education
    @education = Education.find(params[:id])
  end

<<<<<<< HEAD
=======
  # Only allow a list of trusted parameters through.
>>>>>>> 909aa4c (fixed  styles)
  def education_params
    params.require(:education).permit(:school, :country, :city, :education_level, :study_field, :start_date, :end_date, :still_on_this_course, :user_id)
  end
end
