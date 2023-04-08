class UserQuizResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    response = params[:response]
    step = Step.find(params[:quiz_id])
    quiz = step.stepable
    course = step.course

    if JSON.parse(response).to_json == JSON.parse(quiz.answer).to_json
      if current_user
        user_progress = UserProgress.find_by(progressable: step)
        UserQuizResponse.find_or_create_by!(user: current_user, quiz: quiz).update!(response: response)
        unless user_progress.completed?
          user_progress.completed!
          UserPoint.score_me(current_user, step)
        end
      end
      flash[:notice] = t("flash.user_quiz_responses_controller.quiz_passed")
      render js: %(window.location.pathname='#{course_path(course)}')
    else
      flash[:alert] = t("flash.user_quiz_responses_controller.quiz_did_not_passed")
      render js: %(window.location.pathname='#{course_step_path(course, step)}')
    end
  end
end
