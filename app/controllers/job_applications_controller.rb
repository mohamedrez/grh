class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: %i[edit update destroy]

  def index
    @job_applications = JobApplication.all
  end

  def new
    @job_application = JobApplication.new
    @jobs = Job.all
  end

  def edit
  end

  def create
    @job_application = JobApplication.new(job_application_params)

    if @job_application.save
      flash.now[:notice] = t("flash.successfully_created")
      redirect_to job_applications_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @job_application.update(job_application_params)
      flash.now[:notice] = t("flash.successfully_updated")
      redirect_to job_applications_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_application.destroy
    flash.now[:notice] = t("flash.successfully_destroyed")
    redirect_to job_applications_path
  end

  private

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  end

  def job_application_params
    params.require(:job_application).permit(:first_name, :last_name, :email, :phone, :source, :link, :note, :job_id, :resume)
  end
end
