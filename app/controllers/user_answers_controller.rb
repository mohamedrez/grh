class UserAnswersController < ApplicationController
  def new
    @review = Review.find(params[:review_id])
  end

  def create
    text_questions = params[:text_questions]
    single_select_questions = params[:single_select_questions]
    multiple_select_questions = params[:multiple_select_questions]

    UserAnswer.create_user_answers(current_user, text_questions, single_select_questions, multiple_select_questions)

    review = Review.find(params[:review_id])
    redirect_to review_user_answers_path(review), notice: t("flash.successfully_created")
  end
end
