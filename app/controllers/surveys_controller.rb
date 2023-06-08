class SurveysController < ApplicationController
  def show
    @survey = Survey.find(params[:id])
  end

  def new
    @surveyable_type = params[:surveyable_type]
    @surveyable_id = params[:surveyable_id]
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)

    if @survey.save
      @surveyable_id = @survey.surveyable_id
      redirect_to edit_polymorphic_url(id: @surveyable_id), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:name, :surveyable_type, :surveyable_id)
  end
end
