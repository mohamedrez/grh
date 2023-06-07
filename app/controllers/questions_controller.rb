class QuestionsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @section = Section.find(params[:section_id])
    @question = Question.new
    @question.options.build
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @section = Section.find(params[:section_id])
    @question = Question.new(question_params)
    @question.section_id = @section.id

    if @question.save
      redirect_to survey_url(@survey), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :response_type, options_attributes: [:id, :name])
  end
end
