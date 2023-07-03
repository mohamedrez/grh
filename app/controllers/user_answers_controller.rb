class UserAnswersController < ApplicationController
  def new
    @review = Review.find(params[:review_id])
  end

  def create
    review = Review.find(params[:review_id])

    text_questions = params[:text_questions]
    single_select_questions = params[:single_select_questions]
    multiple_select_questions = params[:multiple_select_questions]

    user_answer = UserAnswer.create!(review: review, user: current_user)
    user_answer.create_question_answers(text_questions, single_select_questions, multiple_select_questions)

    redirect_to review_user_answers_path(review), notice: t("flash.successfully_created")
  end
end
