class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update]

  def index
    @q = User.ransack(User.search(params[:q]))
    @users = @q.result.page(params[:page])
    authorize @users
  end

  def show
    authorize @user
  end

  def new
    @user = User.new
    @user.build_address
  end

  def edit
    authorize @user
    @address = @user.address
  end

  def create
    @user = User.new(user_params)
    @user.password = Devise.friendly_token.first(8)
    @user.confirmed_at = Time.now.utc
    @user.build_address(user_params[:address_attributes])

    if @user.save
      @user.send_reset_password_instructions
      redirect_to user_url(@user), notice: t("flash.profiles_controller.account_been_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to user_url(@user), notice: t("flash.profiles_controller.account_been_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :about,
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
      :site_id,
      address_attributes:
      [
        :id,
        :street,
        :country,
        :city,
        :zipcode
      ]
    )
  end
end
