class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: %i[infos show edit update destroy delete_resume update_aasm_state]
  before_action :set_breadcrumbs, only: %i[index show]

  def index
    @job_applications = if params[:job_id]
      JobApplication.where(job_id: params[:job_id]).page(params[:page])
    else
      JobApplication.all.page(params[:page])
    end
  end

  def show
    @user = current_user
    @aasm_logs = AasmLog.where(aasm_logable: @job_application)

    add_breadcrumb(@job_application.first_name)
  end

  def infos
  end

  def new
    @job_application = JobApplication.new
    @jobs = Job.all
    @job_id = params[:job_id]
  end

  def edit
  end

  def create
    @job_application = JobApplication.new(job_application_params)

    if @job_application.save
      flash.now[:notice] = t("flash.successfully_created")
      if params[:job_id].present?
        redirect_to job_job_applications_path(params[:job_id])
      else
        redirect_to job_applications_path
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @job_application.update(job_application_params)
      flash.now[:notice] = t("flash.successfully_updated")
      if params[:job_id].present?
        redirect_to job_job_applications_path(params[:job_id])
      else
        redirect_to job_applications_path
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_application.destroy

    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@job_application),
      turbo_stream.replace("notification_alert", partial: "layouts/alert")
    ]
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
    if params[:job_id]
      add_breadcrumb("Job", jobs_path)
      add_breadcrumb(Job.find(params[:job_id]).title, job_path(params[:job_id]))
    end
    add_breadcrumb(t("views.job_applications.title_job_applications"), job_applications_path)
  end

  def job_application_params
    params.require(:job_application).permit(:first_name, :last_name, :email, :phone, :source, :link, :note, :job_id, :resume)
  end
end
