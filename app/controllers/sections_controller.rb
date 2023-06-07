class SectionsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @section = Section.new
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @section = Section.new(section_params)
    @section.survey_id = @survey.id

    if @section.save
      redirect_to survey_url(@survey), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def section_params
    params.require(:section).permit(:name, :description, :section_type)
  end
end
