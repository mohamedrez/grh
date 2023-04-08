# frozen_string_literal: true

class UserProgressesController < ApplicationController
  before_action :authenticate_user!

  def update
    step = Step.find(params[:step_id])
    course = Course.find(params[:course_id])

    UserProgress.find_by(user: current_user, progressable: step).update_status

    UserPoint.score_me(current_user, step)

    redirect_to course_step_url(course, step)
  end
end
