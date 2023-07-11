class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy]

  def index
    # Shows all courses
    @courses = Course.order(created_at: :desc).page(params[:page])
  end

  def show
    # Shows one course
    @course = Course.find(@course.id)
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to courses_path, notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @course.update(course_params)
      redirect_to course_path(@course), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @course.destroy
      redirect_to courses_path, notice: t("flash.successfully_destroyed")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(
      :id,
      :title,
      :description
    )
  end
end
