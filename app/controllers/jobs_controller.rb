class JobsController < ApplicationController
  layout :determine_layout
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_job, only: %i[show edit update destroy]
  before_action :set_breadcrumbs, only: %i[index show]

  def index
    @url = jobs_path
    @q = Job.ransack(params[:q])
    @jobs = @q.result.page(params[:page])
  end

  def show
    add_breadcrumb(Job.find(@job.id).title, job_path(@job.id))
  end

  def new
    @job = Job.new
  end

  def edit
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to jobs_path, notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @job.update(job_params)
      redirect_to job_path(@job), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @job.destroy
      redirect_to jobs_path, notice: t("flash.successfully_destroyed")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_breadcrumbs
    add_breadcrumb(t("attributes.job.jobs"), jobs_path)
  end

  def job_params
    params.require(:job).permit(
      :id,
      :title,
      :job_type,
      :status,
      :location,
      :remote,
      :overview,
      :min_salary,
      :max_salary,
      :unit,
      :description
    )
  end

  def set_job
    @job = Job.find(params[:id])
  end

  def determine_layout
    if user_signed_in?
      "application"
    else
      "custom_layout"
    end
  end
end
