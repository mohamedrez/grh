class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update]

  def index
    if params[:q].blank?
      @q = User.ransack(params[:q])
    else
      search = params[:q][:last_name_or_email_or_employee_number_cont]
      @q = User.ransack search_hash(search)
    end
    @users = @q.result.page(params[:page])
    authorize @users
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
    @address = @user.address || @user.build_address
    @experiences = @user.experiences
    @educations = @user.educations
  end

  def update
    authorize @user
    respond_to do |format|
      @user.create_address!(user_params[:address_attributes]) unless @user.address
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: t("flash.profiles_controller.account_been_updated") }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
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

  def search_hash(search)
    if search.match?(/\A[a-zA-Z]+\z/)
      {"last_name_cont" => search}
    elsif search.match?(/\A[\w+.\\-]+@[a-z\d\\-]+(\.[a-z\d\\-]+)*\.[a-z]+\z/i)
      {"email_cont" => search}
    elsif search.match?(/\A\d+\z/)
      {"employee_number_cont" => search}
    end
  end
end
