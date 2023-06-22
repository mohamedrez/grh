class JobApplicationsController < ApplicationController
  layout "custom_layout", only: %i[new create]
  before_action :set_job_application, only: %i[infos show edit update destroy delete_resume update_aasm_state]
  skip_before_action :authenticate_user!, only: %i[new create]
  before_action :set_breadcrumbs, only: :index

  def index
    @job_applications = JobApplication.all
  end

  def show
    @user = current_user
    @aasm_logs = AasmLog.where(aasm_logable: @job_application)
  end

  def infos
  end

  def new
    @job_application = JobApplication.new
  end

  def edit
  end

  def create
    @job_application = JobApplication.new(job_application_params)

    if @job_application.save
      flash.now[:notice] = t("flash.successfully_created")
      redirect_to user_signed_in? ? job_applications_path : jobs_path
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

  def update_aasm_state
    aasm_state = params[:aasm_state]
    @job_application.actor_id = current_user.id

    case aasm_state
    when "advanced_to_phone"
      @job_application.advance_job_application_to_phone_screening!
    when "completed_phone"
      @job_application.complete_job_application_phone_screening!
    when "advanced_interview"
      @job_application.advance_job_application_to_interview!
    when "completed_interview"
      @job_application.complete_job_application_to_interview!
    when "disqualified"
      @job_application.disqualify_applicant!
    end

    redirect_to job_application_path(@job_application)
  end

  def delete_resume
    @job_application.resume.destroy
    redirect_to job_application_path(@job_application), notice: t("flash.receipt_successfully_deleted")
  end

  private

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.job_applications.title_job_applications"), job_applications_path)
  end

  def job_application_params
    params.require(:job_application).permit(:first_name, :last_name, :email, :phone, :source, :link, :note, :job_id, :resume)
  end
end
