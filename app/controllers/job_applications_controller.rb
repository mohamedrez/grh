class JobApplicationsController < ApplicationController
  before_action :layout_handler
  skip_before_action :authenticate_user!, only: %i[new create]
  before_action :set_job_application, only: %i[infos show edit update destroy delete_resume update_aasm_state]
  before_action :set_breadcrumbs, only: %i[index show]
  before_action :set_job, only: %i[show new edit]

  def index
    @q = if params[:job_id]
      @url = job_job_applications_path
      JobApplication.where(job_id: params[:job_id]).ransack(params[:q])
    else
      @url = job_applications_path
      JobApplication.all.ransack(params[:q])
    end
    @job_applications = @q.result.page(params[:page])
  end

  def show
    @user = current_user
    @aasm_logs = AasmLog.where(aasm_logable: @job_application)

    if @job_id
      add_breadcrumb(@job_application.first_name, job_job_application_path(@job_id, @job_application))
    else
      add_breadcrumb(@job_application.first_name, job_application_path(@job_application))
    end
  end

  def infos
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
        if user_signed_in?
          redirect_to job_job_applications_path(params[:job_id])
        else
          redirect_to jobs_path
        end
      else
        redirect_to job_applications_path
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_application.destroy

    @job_applications = if params[:job_id]
      JobApplication.where(job_id: params[:job_id]).page(params[:page])
    else
      JobApplication.all.page(params[:page])
    end

    flash.now[:notice] = t("flash.successfully_destroyed")
    render turbo_stream: [
      turbo_stream.remove(@job_application),
      turbo_stream.replace("paginate", partial: "job_applications/paginate", locals: {job_applications: @job_applications}),
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

    if params[:job_id].present?
      redirect_to job_job_application_path(@job_application, params[:job_id])
    else
      redirect_to job_application_path(@job_application)
    end
  end

  def delete_resume
    @job_application.resume.destroy
    redirect_to job_application_path(@job_application), notice: t("flash.receipt_successfully_deleted")
  end

  private

  def layout_handler
    if user_signed_in?
      self.class.skip_before_action
    else
      self.class.layout "custom_layout", only: %i[new create]
    end
  end

  def set_job
    @job_id = params[:job_id]
  end

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  end

  def set_breadcrumbs
    if params[:job_id]
      add_breadcrumb(t("attributes.job.jobs"), jobs_path)
      add_breadcrumb(Job.find(params[:job_id]).title, job_path(params[:job_id]))
      add_breadcrumb(t("views.job_applications.title_job_applications"), job_job_applications_path(params[:job_id]))
    else
      add_breadcrumb(t("views.job_applications.title_job_applications"), job_applications_path)
    end
  end

  def job_application_params
    params.require(:job_application).permit(:first_name, :last_name, :email, :phone, :source, :link, :note, :job_id, :resume)
  end
end
