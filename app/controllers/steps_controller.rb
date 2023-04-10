# frozen_string_literal: true

require "json"

class StepsController < ApplicationController
  before_action :set_course_step, only: [:show]

  def index
    @steps = Step.where(course_id: params[:course_id])
  end

  def show
    @track = Track.find(@course.track_id)
    @index_plus_one = @course.steps.index(@step) + 1
    @index_minus_one = @course.steps.index(@step) - 1

    unless @step.which_type == "audio"
      @my_asset = @step.stepable.get_my_asset
    end

    if current_user
      @up_status = @step.up_status current_user
      @user_progress = UserProgress.find_by!(user: current_user, progressable: @step)
    end
  end

  private

  def set_course_step
    @course = Course.find(params[:course_id])
    @step = Step.find(params[:id])
  end
end
