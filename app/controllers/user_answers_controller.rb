class UserAnswersController < ApplicationController
  def new
    @review = Review.find(params[:review_id])
  end

  def create
    # Not yet completed

    # @review = Review.find(params[:review_id])
    # @answer_question = params[:answer_question]

    # @answer_question.each do |key, value|
    #   @text_response = TextResponse.create!(content: value)
    #   @user_answer = UserAnswer.create!(question_id: key, user_id: current_user.id, answerable: @text_response)
    # end

    # redirect_to review_user_answers_path(@review), notice: t("flash.successfully_created")
  end
end
