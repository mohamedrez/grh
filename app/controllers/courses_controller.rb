# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @track = Track.find(params[:track_id])
    @courses = @track.courses
  end

  def show
    @course = Course.find(params[:id])
    @track = Track.find(@course.id)
    @progress_hash = {}
    return unless current_user
    @progress_hash = @course.get_steps_status(current_user)
  end
end
