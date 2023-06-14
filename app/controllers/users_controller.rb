class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :set_breadcrumbs, only: %i[index show new edit]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.page(params[:page])
  end

  def show
    @manager = User.find_by(id: @user.manager_id)

    add_breadcrumb(@user.full_name)
  end

  def new
    authorize!

    @user = User.new
    @user.build_address
    @manager_select = User.all.map { |user| [user.full_name, user.id] }

    add_breadcrumb(t("views.users.add_employee"))
  end

  def edit
    authorize!

    @manager_select = User.where.not(id: @user.id)&.map { |user| [user.full_name, user.id] }
    @address = @user.address || @user.build_address

    add_breadcrumb(@user.full_name, @user)
    add_breadcrumb(t("views.users.edit_employee"))
  end

  def create
    authorize!

    @user = User.new(user_params)
    @user.password = Devise.friendly_token.first(8)
    @user.confirmed_at = Time.now.utc
    @user.build_address(user_params[:address_attributes])

    if @user.save
      DeviseCustomMailer.with(user: @user).confirmation_instructions.deliver_now
      redirect_to user_url(@user), notice: t("flash.successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize! @user

    if @user.update(user_params)
      redirect_to user_url(@user), notice: t("flash.successfully_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def import
    if params[:file].present?
      User.import(params[:file])
      redirect_to users_path, notice: t("flash.successfully_imported")
    else
      redirect_to users_path, alert: t("errors.select_csv")
    end
  rescue => e
    Rails.logger.error e.message
    redirect_to users_path, alert: t("flash.there_is_an_error_in_your_file")
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_breadcrumbs
    add_breadcrumb(t("views.users.employees_title"), users_path)
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :about,
      :avatar,
      :birthdate,
      :start_date,
      :end_date,
      :gender,
      :marital_status,
      :phone,
      :email,
      :children_number,
      :cin,
      :service,
      :job_title,
      :joining_date,
      :contract,
      :category,
      :cnss_number,
      :employee_number,
      :brut_salary,
      :net_salary,
      :cnss_contribution,
      :retirement_contribution,
      :pto_number,
      :manager_id,
      :site_id,
      address_attributes:
      [
        :id,
        :street,
        :country,
        :city,
        :zipcode
      ],
      experiences_attributes:
      [
        :id,
        :job_title,
        :company_name,
        :employment_type,
        :start_date,
        :end_date,
        :country,
        :city,
        :work_description
      ],
      educations_attributes: [
        :id,
        :school,
        :country,
        :city,
        :education_level,
        :study_field,
        :start_date,
        :end_date,
        :still_on_this_course
      ]
    )
  end
end
