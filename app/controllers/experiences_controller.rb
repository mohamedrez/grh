class ExperiencesController < ApplicationController
  before_action :set_experience, only: %i[edit update]

  def new
    @experience = Experience.new
  end

  def edit
  end

  def create
    @experience = Experience.new(experience_params)

    respond_to do |format|
      if @experience.save
        format.html { redirect_to edit_user_url(@experience.user), notice: t("experiences.experience_created") }
        format.json { render :show, status: :created, location: @experience }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @experience.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @experience.update(experience_params)
        format.html { redirect_to edit_user_url(@experience.user), notice: t("experiences.experience_updated") }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_experience
    @experience = Experience.find(params[:id])
  end

  def experience_params
    params.require(:experience).permit(:job_title, :company_name, :employment_type, :start_date, :end_date, :work_description, :user_id)
  end
end
