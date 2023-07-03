class UserAnswersController < ApplicationController
  before_action :set_locals, only: %i[show new create]
  before_action :set_breadcrumbs, only: %i[show new]

  def show
    @user_answer = UserAnswer.find(params[:id])
  end

  def new
  end

  def create
    text_questions = params[:text_questions]
    single_select_questions = params[:single_select_questions]
    multiple_select_questions = params[:multiple_select_questions]

    user_answer = UserAnswer.create!(review: @review, author: current_user, user: @user)
    user_answer.create_question_answers(text_questions, single_select_questions, multiple_select_questions)

    redirect_to review_user_answer_path(@review, user_answer), notice: t("flash.successfully_created")
  end

  private

  def set_locals
    @user = User.find(params[:user_id])
    @review = Review.find(params[:review_id])
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.reviews.performance_reviews"), reviews_path)
    add_breadcrumb(@review.name, review_path(@review))
    add_breadcrumb(@user.full_name.humanize)
  end
end
